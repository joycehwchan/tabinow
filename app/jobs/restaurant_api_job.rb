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

    Content.create!(name: restaurants_selected["name"],
                    price: set_yelp_price(restaurants_selected["price"]),
                    location: restaurant_location,
                    rating: restaurants_selected["rating"],
                    category:,
                    description: restaurants_selected["categories"].first["title"],
                    api: "",
                    status: 0)
  end

  def set_yelp_price(price_string)
    case
    when price_string.nil? || price_string == " " then return 0
    when price_string == "￥" then return 10
    when price_string == "￥￥" then return 30
    when price_string == "￥￥￥" then return 60
    when price_string == "￥￥￥￥" then return 100
    end
  end
end
