class Itinerary < ApplicationRecord
  belongs_to :employee, class_name: "User", optional: true
  belongs_to :client, class_name: "User", optional: true
  has_many :days, dependent: :destroy
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
    total_days.times do |i|
      day = Day.new(number: i + 1)
      day.itinerary = self
      if day.save!
        # new_category_and_item("Accommodation", day)
        # new_category_and_item("Restaurant", day)
        # new_category_and_item("Activity", day)
      end
    end
  end


  def new_category_and_item(item_category, day)
    if item_category == "Accommodation"
      category = Category.new(title: "Accommodation",
                              sub_category: "Not Set",
                              day:)
      if category.save!
        # set_accommodation
        AccommodationApiJob.perform_later(itineraries_params, min_price_generator, max_price_generator, @itinerary, category) # <- The job is queued
      end
    elsif item_category == "Restaurant"
      food_times = ["Lunch", "Dinner"]
      food_times.each do |food_time|
        category = Category.new(title: "Restaurant",
                                sub_category: food_time,
                                day:)
        if category.save!
          RestaurantApiJob.perform_later(food_time, max_price_generator, @itinerary, category) # <- The job is queued
        end
      end
    else
      2.times do
        category = Category.new(title: "Activity",
                                sub_category: "Not Set",
                                day:)
        if category.save!
          ActivityApiJob.perform_later(max_price_generator, @itinerary, category) # <- The job is queued
        end
      end
    end
  end

  def min_price_generator
    min_price = @itinerary.min_budget.to_i
    return min_price
  end

  def max_price_generator
    max_price = @itinerary.max_budget.to_i
    return max_price
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

    activities = ActivityApiService.new(location: params[:location],
                                        keyword: "activities",
                                        number_people: params[:number_people],
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
