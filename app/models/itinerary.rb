class Itinerary < ApplicationRecord
  belongs_to :employee, class_name: "User", optional: true
  belongs_to :client, class_name: "User", optional: true
  has_many :days, dependent: :destroy
  has_many :categories, through: :days
  has_many :contents, through: :categories
  validates :title, presence: true
  validates :status, presence: true
  validate  :min_budget_cannot_be_higher_than_max_budget
  validate :itinerary_duration
  enum :status, ["draft", "pending", "confirmed", "rejected"], default: :pending
  validates :location, presence: true

  def min_budget_cannot_be_higher_than_max_budget
    return unless min_budget.present? && max_budget.present? && min_budget > max_budget

    errors.add(:max_budget, "Can't be smaller then min budget")
  end

  def total_budget
    sum_of_a_itinerary = 0
    days_array = days
    days_array.each do |day|
      contents_array = day.contents
      contents_array.each do |content|
        sum_of_a_itinerary += content.price
      end
    end
    return sum_of_a_itinerary
  end

  def total_days
    if start_date.nil? || end_date.nil?
      days.count
    else
      (end_date - start_date).to_i
    end
  end

  def itinerary_duration
    return unless start_date.present? && end_date.present? && (end_date - start_date).to_i.zero?

    errors.add(:base, "Minimum itinerary duration 1 Day")
  end

  def set_new_client(client_info = {})
    return unless client_info[:email]

    generic_password = "tabinow"
    client = User.where(client_info).first_or_initialize
    client.password = generic_password unless client.id
    client.save
    self.client = client
  end

  def new_day(total_days)
    category_array = []
    total_days.times do |i|
      day = Day.new(number: i + 1)
      day.itinerary = self
      next unless day.save!

      category = Category.new(title: "Accommodation",
                              sub_category: "Not Set",
                              day:)
      category.save!
      category_array.push(category)
      new_morning_category_item(day)
      new_afternoon_category_item(day)
    end
    accommodation(category_array)
  end

  def accommodation(category_array)
    AccommodationApiJob.perform_now(self, min_price_generator, max_price_generator, category_array)
  end

  def new_morning_category_item(day)
    MorningApiJob.perform_now(self, max_price_generator, day)
  end

  def new_afternoon_category_item(day)
    AfternoonApiJob.perform_now(self, max_price_generator, day)
  end

  def min_price_generator
    min_price = min_budget.to_i
    return min_price / total_days
  end

  def max_price_generator
    max_price = max_budget.to_i
    return max_price  / total_days
  end

  def set_activity_budget
    activity_budget = max_price_generator / 6
    set_activity_budget = []

    if activity_budget >= 60
      set_activity_budget = "1, 2, 3, 4"
    elsif activity_budget >= 30 && activity_budget < 60
      set_activity_budget = "1, 2, 3"
    elsif activity_budget >= 10 && activity_budget < 30
      set_activity_budget = "1, 2"
    else
      set_activity_budget = "1"
    end

    activities = ActivityApiService.new(location: location,
                                        keyword: "activities",
                                        number_people: umber_people,
                                        price: set_activity_budget)
    begin
      activities_results = activities.call
      activity_selected = activities_results.sample
    rescue StandardError
      retry
    end

    activity_selected["location"]["display_address"].nil? ? activity_location = location : activity_location = activity_selected["location"]["display_address"].first

    Content.create!(name: activity_selected["name"],
                    price: set_yelp_price(activity_selected["price"]),
                    location: activity_location,
                    rating: activity_selected["rating"],
                    category: Category.last,
                    description: activity_selected["categories"].first["title"],
                    api: "",
                    status: 0)
  end
end
