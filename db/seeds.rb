def accomodation(location)
  # This will be moved at a later date...

  # The API URL to get the area code for the hotel search (adding the location to the query)
  url = URI("https://hotels4.p.rapidapi.com/locations/v3/search?q=#{location}&locale=en_US&langid=1033&siteid=300000001")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  # Adding the API-key
  request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = '2ce7422325msh1413b85402383f0p1d4a08jsn506805417938'
  request["X-RapidAPI-Host"] = 'hotels4.p.rapidapi.com'

  # Making the API call
  response = http.request(request)

  # Converting the reponse body into JSON
  result = JSON.parse(response.body)

  # Getting the location id for the hotel seach
  search_location = result["sr"][0]["gaiaId"]

  # The API to get hotels
  url = URI("https://hotels4.p.rapidapi.com/properties/v2/list")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  # Adding the API-key
  request = Net::HTTP::Post.new(url)
  request["content-type"] = 'application/json'
  request["X-RapidAPI-Key"] = '2ce7422325msh1413b85402383f0p1d4a08jsn506805417938'
  request["X-RapidAPI-Host"] = 'hotels4.p.rapidapi.com'

  # Sending the POST body with all the search params (including the location id fro above)
  request.body = "{\n \"currency\": \"USD\",\n \"eapid\": 1,\n \"locale\": \"en_US\",\n \"siteId\": 300000001,\n \"destination\": {\n  \"regionId\": \"#{search_location}\"\n },\n \"checkInDate\": {\n  \"day\": 10,\n  \"month\": 10,\n  \"year\": 2023\n },\n \"checkOutDate\": {\n  \"day\": 15,\n  \"month\": 10,\n  \"year\": 2023\n },\n \"rooms\": [\n  {\n   \"adults\": 2,\n   \"children\": [\n    {\n     \"age\": 5\n    },\n    {\n     \"age\": 7\n    }\n   ]\n  }\n ],\n \"resultsStartingIndex\": 0,\n \"resultsSize\": 200,\n \"sort\": \"PRICE_LOW_TO_HIGH\",\n \"filters\": {\n  \"price\": {\n   \"max\": 150,\n   \"min\": 100\n  }\n }\n}"

  # Making the API call
  response = http.request(request)

  # Converting the reponse body into JSON
  result = JSON.parse(response.body)

  # Selecting the hotels from the results
  search_hotels = result["data"]["propertySearch"]["properties"]

  # Preparing an empty array to push the hotel names into
  hotels = []
  # Looping through the hotels from the api
  search_hotels.each do |hotel|
    # Puushing the hotel names into the array
    hotels.push(hotel["name"])
  end

  return hotels
end

# Setting the location for the API call
hotels_names = accomodation("tokyo")

def restuarants(location)
  url = URI("https://api.yelp.com/v3/businesses/search?location=#{location},Japan&term=restaurants&limit=50")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)

  key = 'Bearer SxGC-lIGxglEDFDoPWQVvrfYG_dPbKKsf07_1lv4PPN8QHzYs9PAZSCPvbFONVRzRj4S-08QRXfRjvmhvoKdASJkWApQ_BSM3P037WPDuWvbvJ1knBFBu7Tv-7l9Y3Yx'
  request['Authorization'] = key

  response = http.request(request)

  restuarants = JSON.parse(response.body)["businesses"]

  return restuarants
end

search_restuarants = []
restuarants("tokyo").each do |restuarant|
  search_restuarants.push(restuarant)
end


def activities(location)
  url = URI("https://api.yelp.com/v3/businesses/search?location=#{location},Japan&term=activities&limit=50")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)

  key = 'Bearer SxGC-lIGxglEDFDoPWQVvrfYG_dPbKKsf07_1lv4PPN8QHzYs9PAZSCPvbFONVRzRj4S-08QRXfRjvmhvoKdASJkWApQ_BSM3P037WPDuWvbvJ1knBFBu7Tv-7l9Y3Yx'
  request['Authorization'] = key

  response = http.request(request)

  activities = JSON.parse(response.body)["businesses"]

  return activities
end

search_activities = []
activities("tokyo").each do |activity|
  search_activities.push(activity)
end

puts "--------------------------"
puts " --- Seeds for TabiNow ---"
puts "--------------------------"
puts " - Removing old Users (with addresses) -"

# Destroying all the Users
User.destroy_all

puts " - Starting to create Users -"

# Creating Employee user:
employee = User.new(name: "Joyce",
                    email: "emp@tabinow.tours",
                    phone: Faker::PhoneNumber.cell_phone_in_e164,
                    password: "Password123",
                    admin: true)
employee.save!

#  User.create!(name: "Joyce",email: "emp@tabinow.tours",phone: Faker::PhoneNumber.cell_phone_in_e164,password: "Password123",admin: true)

5.times do
  client = User.new(name: ["Discover Tours", "Luxury Travels Inc", "Adventure Travels", "The Travellers", "Paul Smith", "Amy L."].sample,
                    email: Faker::Internet.email,
                    phone: Faker::PhoneNumber.cell_phone_in_e164,
                    password: "Password123",
                    admin: false)
  client.save!
end

puts " - Number of users created: #{User.count} -"
puts "--------------------------"
puts " - Removing old Itineraries (days and activities) -"

# Destroying everything related to the itineraries (days and contents)
Itinerary.destroy_all
Day.destroy_all
Content.destroy_all
Category.destroy_all


puts " - Starting to create Itineraries -"
start_date = Date.today
end_date = start_date + rand(3..10)
min_budget = rand(1..10) * 10000
max_budget = min_budget + (rand(5..10) * [1000 ,10000].sample)
SPECIALREQUESTDATA= ["Mandarin speaking guide", "Only vegetarian meals", "Should include a Japanese tea ceremony", "Should include Disneyland", "Please add Universal studio!"]
# Seed for itinerary
5.times do |index|
  # Selecting employee from user db
  employee = User.find_by(admin: true)
  client = User.where(admin: false).sample
  # Selecting client from user db
  # Creating a variable with a location in Japan
  location = ["Tokyo", "Kyoto", "Hokkaido", "Okinawa", "Nagoya", "Osaka"].sample
  # Randomly generates a number of days
  days_number = rand(1..5)
  # setting hotel for this itinerary
  set_hotel = hotels_names.sample

  # Createing itinerary
  puts " - ##{index + 1}/5: #{days_number} days in #{location}"

  itinerary = Itinerary.create!(title: "#{days_number} Days in #{location}",
                                location: location,
                                status: rand(0..3),
                                client: client,
                                employee: employee,
                                start_date: start_date,
                                end_date: end_date,
                                min_budget: min_budget,
                                max_budget: max_budget,
                                special_request: SPECIALREQUESTDATA.sample
                              )

  # Generate stay, restuarants, activities
  itinerary.total_days.times do |day_number|
  # Creating a Day db
  # Adding +1
  day = Day.new(number: day_number + 1, itinerary: itinerary)
  day.save!


  puts " - Day #{day_number + 1}:"

  # Generate stay
  category = Category.new(title: "Accommodation", sub_category: "123", day: day)
  category.save!
  stay = Content.new(name: set_hotel,
                    price: rand(15_000..100_000),
                    location: location,
                    category: Category.last,
                    rating: rand(1..5),
                    description: Faker::Lorem.paragraph(sentence_count: 2),
                    api: "",
                    status: rand(0..3))
  stay.save!
  puts "   Stay: #{Content.last.name}"

  # Generate restuarant for lunch

  def set_price(price_string)
    case
    when price_string.nil? || price_string == " " then return 0
    when price_string == "￥" then return 10
    when price_string == "￥￥" then return 30
    when price_string == "￥￥￥" then return 60
    when price_string == "￥￥￥￥" then return 100
    end
  end

  def check_api_location(api_location, location)
    case
    when api_location.nil? then return location
    when !api_location.nil? then return api_location
    end
  end

    # Generate restuarant for lunch
  set_lunch_restaurant = search_restuarants.sample
  category = Category.new(title: "Restaurant", sub_category: "Lunch", day: day)
  category.save!
  lunch = Content.new(name: set_lunch_restaurant["name"],
                      price: set_price(set_lunch_restaurant["price"]),
                      location: check_api_location(set_lunch_restaurant["display_address"], location),
                      category: Category.last,
                      rating: set_lunch_restaurant["rating"],
                      description: set_lunch_restaurant["categories"].first["title"],
                      api: "",
                      status: rand(0..3))
  lunch.save!
  puts "   Lunch: #{Content.last.name} (#{Content.last.description})"

  # Generate restuarant for dinner
  set_dinner_restaurant = search_restuarants.sample

  category = Category.new(title: "Restaurant", sub_category: "Dinner", day: day)
  category.save!
  dinner = Content.new(name: set_dinner_restaurant["name"],
                      price: set_price(set_dinner_restaurant["price"]),
                      location: check_api_location(set_dinner_restaurant["display_address"], location),
                      category: Category.last,
                      rating: set_dinner_restaurant["rating"],
                      description: set_dinner_restaurant["categories"].first["title"],
                      api: "",
                      status: rand(0..3))
  dinner.save!
  puts "   Dinner: #{Content.last.name} (#{Content.last.description})"

  # Generate morning activity
  set_morning_activity = search_activities.sample
  category = Category.new(title: "Activity", sub_category: "Museum", day: day)
  category.save!
  morning_activity = Content.new(name: set_morning_activity["name"],
                                 price: set_price(set_morning_activity["price"]),
                                 location: check_api_location(set_morning_activity["display_address"], location),
                                 category: Category.last,
                                 rating: set_morning_activity["rating"],
                                 description: set_morning_activity["categories"].first["title"],
                                 api: "",
                                 status: rand(0..3))
  morning_activity.save!

  puts "   Morning Activity: #{Content.last.name} (#{Content.last.description})"

  # Generate afternoon activity
  set_afternoon_activity = search_activities.sample
  category = Category.new(title: "Activity", sub_category: "Historic Sites", day: day)
  category.save!
  afternoon_activity = Content.new(name: set_afternoon_activity["name"],
                                   price: set_price(set_afternoon_activity["price"]),
                                   location: check_api_location(set_afternoon_activity["display_address"], location),
                                   category: Category.last,
                                   rating: set_afternoon_activity["rating"],
                                   description: set_afternoon_activity["categories"].first["title"],
                                   api: "",
                                   status: rand(0..3))
  afternoon_activity.save!
  puts "   Afternoon Activity: #{Content.last.name} (#{Content.last.description})"
  end
end
puts "--------------------------"
puts " - Number of itineraries created: #{Itinerary.count} -"
puts "--------------------------"
puts " - Seeds done -"
puts "--------------------------"
