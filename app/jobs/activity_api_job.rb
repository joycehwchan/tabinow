class ActivityApiJob < ApplicationJob
  queue_as :default

  def perform(itinerary, max_price_generator, category)
    # Do something later
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

    activities = ActivityApiService.new(location: itinerary.location,
                                        keyword: "activities",
                                        number_people: 2,
                                        price: set_activity_budget)

    begin
      activities_results = activities.call
      activity_selected = activities_results.sample
    rescue
      retry
    end

    activity_selected["location"]["display_address"].nil? ? activity_location = location : activity_location = activity_selected["location"]["display_address"].first

    activity = Content.new(name: activity_selected["name"],
                           price: yelp_price(activity_selected["price"]),
                           location: activity_location,
                           rating: activity_selected["rating"],
                           category:,
                           description: activity_selected["categories"].first["title"],
                           api: activity_selected["id"],
                           status: 0)

    if activity_selected["image_url"].present?
      activity_image = URI.parse(activity_selected["image_url"]).open
      activity.image.attach(io: activity_image,
                            filename: "restaurant_#{activity_selected['id']}.png",
                            content_type: "image/png")
    end
    activity.save!
  end

  def yelp_price(price_string)
    case
    when price_string.nil? || price_string == " " then return 0
    when price_string == "￥" then return 10
    when price_string == "￥￥" then return 30
    when price_string == "￥￥￥" then return 60
    when price_string == "￥￥￥￥" then return 100
    end
  end
end
