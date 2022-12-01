class AfternoonApiJob < ApplicationJob
  queue_as :default

  def perform(itinerary, max_price_generator, day)
    activity_category = Category.new(title: "Activity",
                                     sub_category: "Not Set",
                                     day:)
    activity_category.save!

    p itinerary

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
                                        keyword: itinerary.interests.delete(''),
                                        number_people: 2,
                                        price: set_activity_budget)

    begin
      activities_results = activities.call
      activity_selected = activities_results.sample
    rescue
      retry
    end

    activity_selected["location"]["display_address"].nil? ? activity_location = location : activity_location = activity_selected["location"]["display_address"].first
    activity_latitude = activity_selected["coordinates"]["latitude"]
    activity_longitude = activity_selected["coordinates"]["longitude"]
    activity = Content.new(name: activity_selected["name"],
                           price: yelp_price(activity_selected["price"]),
                           location: activity_location,
                           rating: activity_selected["rating"],
                           category: activity_category,
                           description: activity_selected["categories"].first["title"],
                           api: activity_selected["id"],
                           latitude: activity_latitude,
                           longitude: activity_longitude,
                           status: 0)

    if activity_selected["image_url"].present?
      activity_image = URI.parse(activity_selected["image_url"]).open
      activity.image.attach(io: activity_image,
                            filename: "restaurant_#{activity_selected['id']}.png",
                            content_type: "image/png")
    end
    activity.save!

    # Lunch
    lunch_category = Category.new(title: "Restaurant",
                                  sub_category: "Lunch",
                                  day:)
    lunch_category.save!

    restaurant_budget = max_price_generator / 5
    set_restaurant_budget = []

    if restaurant_budget >= 60
      set_restaurant_budget = "1, 2, 3, 4"
    elsif restaurant_budget >= 30 && restaurant_budget < 60
      set_restaurant_budget = "1, 2, 3"
    elsif restaurant_budget >= 10 && restaurant_budget < 30
      set_restaurant_budget = "1, 2"
    else
      set_restaurant_budget = "1"
    end
    restaurants = RestaurantApiService.new(latitude: activity_latitude,
                                           longitude: activity_longitude,
                                           keyword: "restaurants",
                                           price: set_restaurant_budget)
    begin
      restaurants_results = restaurants.call
      restaurants_selected = restaurants_results.sample
    # rescue
    #   retry
    end

    restaurants_selected["location"]["display_address"].nil? ? restaurant_location = activity_location : restaurant_location = restaurants_selected["location"]["display_address"].first
    restaurant_latitude = restaurants_selected["coordinates"]["latitude"]
    restaurant_longitude = restaurants_selected["coordinates"]["longitude"]
    restaurant = Content.new(name: restaurants_selected["name"],
                             price: yelp_price(restaurants_selected["price"]),
                             location: restaurant_location,
                             rating: restaurants_selected["rating"],
                             category: lunch_category,
                             description: restaurants_selected["categories"].first["title"],
                             api: restaurants_selected["id"],
                             latitude: restaurant_latitude,
                             longitude: restaurant_longitude,
                             status: 0)

    if restaurants_selected["image_url"].present?
      restaurant_image = URI.parse(restaurants_selected["image_url"]).open
      restaurant.image.attach(io: restaurant_image,
                              filename: "restaurant_#{restaurants_selected['id']}.png",
                              content_type: "image/png")
    end
    restaurant.save!

    activities_results.delete(activity_selected)

    activities_results.take(0).each do |unused_activity|
      unused_activity["location"]["display_address"].nil? ? activity_location = location : activity_location = unused_activity["location"]["display_address"].first
      activity_latitude = unused_activity["coordinates"]["latitude"]
      activity_longitude = unused_activity["coordinates"]["longitude"]
      # Loop and save
      new_unused_activities = UnusedContent.new(name: unused_activity["name"],
                                                price: yelp_price(unused_activity["price"]),
                                                location: activity_location,
                                                category_title: "Activity",
                                                category_sub_category: "",
                                                description: unused_activity["categories"].first["title"],
                                                rating: unused_activity["rating"],
                                                api: unused_activity["id"],
                                                latitude: activity_latitude,
                                                longitude: activity_longitude,
                                                itinerary:itinerary)
      if unused_activity["image_url"].present?
        # Fetching teh image and saving it in ActiveStorage/Cloudinary
        activity_image = URI.parse(unused_activity["image_url"]).open
        new_unused_activities.image.attach(io: activity_image,
                                           filename: "restaurant_#{unused_activity['id']}.png",
                                           content_type: "image/png")
      end
      new_unused_activities.save!

    end

    restaurants_results.delete(restaurants_selected)

    restaurants_results.take(0).each do |unused_restaurant|
      unused_restaurant["location"]["display_address"].nil? ? restaurant_location = location : restaurant_location = unused_restaurant["location"]["display_address"].first
      restaurant_latitude = unused_restaurant["coordinates"]["latitude"]
      restaurant_longitude = unused_restaurant["coordinates"]["longitude"]
      # Loop and save
      new_unused_restaurant = UnusedContent.new(name: unused_restaurant["name"],
                                                price: yelp_price(unused_restaurant["price"]),
                                                location: restaurant_location,
                                                category_title: "Restaurant",
                                                category_sub_category: "",
                                                description: unused_restaurant["categories"].first["title"],
                                                rating: unused_restaurant["rating"],
                                                api: unused_restaurant["id"],
                                                latitude: restaurant_latitude,
                                                longitude: restaurant_longitude,
                                                itinerary:itinerary)
      if unused_restaurant["image_url"].present?
        # Fetching teh image and saving it in ActiveStorage/Cloudinary
        restaurant_image = URI.parse(unused_restaurant["image_url"]).open
        new_unused_restaurant.image.attach(io: restaurant_image,
                                           filename: "restaurant_#{unused_restaurant['id']}.png",
                                           content_type: "image/png")
      end
      new_unused_restaurant.save!
    end
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
