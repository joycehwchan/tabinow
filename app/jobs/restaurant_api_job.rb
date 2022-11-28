class RestaurantApiJob < ApplicationJob
  queue_as :default

  def perform(itinerary, food_time, max_price_generator, category)
    # Do something later
    if food_time == "Lunch"
      restaurant_budget = max_price_generator / 10
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
      restaurants = RestaurantApiService.new(location: itinerary.location,
                                             keyword: "Best Lunch restaurants",
                                             price: set_restaurant_budget)
    else
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
      restaurants = RestaurantApiService.new(location: itinerary.location,
                                             keyword: "Best Dinner restaurants",
                                             price: set_restaurant_budget)
    end
    begin
      restaurants_results = restaurants.call
      restaurants_selected = restaurants_results.sample
    rescue
      retry
    end

    restaurants_selected["location"]["display_address"].nil? ? restaurant_location = location : restaurant_location = restaurants_selected["location"]["display_address"].first

    restaurant = Content.new(name: restaurants_selected["name"],
                             price: yelp_price(restaurants_selected["price"]),
                             location: restaurant_location,
                             rating: restaurants_selected["rating"],
                             category:,
                             description: restaurants_selected["categories"].first["title"],
                             api: restaurants_selected["id"],
                             status: 0)

    if restaurants_selected["image_url"].present?
      restaurant_image = URI.parse(restaurants_selected["image_url"]).open
      restaurant.image.attach(io: restaurant_image,
                              filename: "restaurant_#{restaurants_selected['id']}.png",
                              content_type: "image/png")
    end
    restaurant.save!

    restaurants_results.delete(restaurants_selected)

    restaurants_results.take(12).each do |unused_restaurant|
      unused_restaurant["location"]["display_address"].nil? ? restaurant_location = location : restaurant_location = unused_restaurant["location"]["display_address"].first

      # Loop and save
      new_unused_restaurant = UnusedContent.new(name: unused_restaurant["name"],
                                                price: yelp_price(unused_restaurant["price"]),
                                                location: restaurant_location,
                                                category_title: "Restaurant",
                                                category_sub_category: unused_restaurant["categories"].first["title"],
                                                description: unused_restaurant["categories"].first["title"],
                                                rating: unused_restaurant["rating"],
                                                api: unused_restaurant["id"])
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
