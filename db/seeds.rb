def accomodation(location)
  url = URI("https://hotels4.p.rapidapi.com/locations/v3/search?q=#{location}&locale=en_US&langid=1033&siteid=300000001")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = '2ce7422325msh1413b85402383f0p1d4a08jsn506805417938'
  request["X-RapidAPI-Host"] = 'hotels4.p.rapidapi.com'

  response = http.request(request)
  result = JSON.parse(response.body)

  search_location = result["sr"][0]["gaiaId"]

  url = URI("https://hotels4.p.rapidapi.com/properties/v2/list")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(url)
  request["content-type"] = 'application/json'
  request["X-RapidAPI-Key"] = '2ce7422325msh1413b85402383f0p1d4a08jsn506805417938'
  request["X-RapidAPI-Host"] = 'hotels4.p.rapidapi.com'
  request.body = "{\n    \"currency\": \"USD\",\n    \"eapid\": 1,\n    \"locale\": \"en_US\",\n    \"siteId\": 300000001,\n    \"destination\": {\n        \"regionId\": \"#{search_location}\"\n    },\n    \"checkInDate\": {\n        \"day\": 10,\n        \"month\": 10,\n        \"year\": 2023\n    },\n    \"checkOutDate\": {\n        \"day\": 15,\n        \"month\": 10,\n        \"year\": 2023\n    },\n    \"rooms\": [\n        {\n            \"adults\": 2,\n            \"children\": [\n                {\n                    \"age\": 5\n                },\n                {\n                    \"age\": 7\n                }\n            ]\n        }\n    ],\n    \"resultsStartingIndex\": 0,\n    \"resultsSize\": 200,\n    \"sort\": \"PRICE_LOW_TO_HIGH\",\n    \"filters\": {\n        \"price\": {\n            \"max\": 150,\n            \"min\": 100\n        }\n    }\n}"

  response = http.request(request)
  result = JSON.parse(response.body)

  search_hotels = result["data"]["propertySearch"]["properties"]
  hotels = []
  search_hotels.each do |hotel|
    hotels.push(hotel["name"])
  end
  return hotels.sample
end

accomodation("tokyo")

puts " --- Seeds for TabiNow ---"
puts "--------------------------"
puts " - Removing old Users (with addresses) -"

User.destroy_all

puts " - Starting to create Users -"

# Creating Employee user:
employee = User.new(name: "TabiNowEmp",
                    email: "emp@tabinow.tours",
                    phone: Faker::PhoneNumber.cell_phone_in_e164,
                    password: "Password123",
                    admin: true)
employee.save!

5.times do
  client = User.new(name: Faker::TvShows::ParksAndRec.character,
                    email: Faker::Internet.email,
                    phone: Faker::PhoneNumber.cell_phone_in_e164,
                    password: "Password123",
                    admin: false)
  client.save!
end

puts " - Number of users created: #{User.count} -"
puts "--------------------------"
puts " - Removing old Itineraries (days and activities) -"
Itinerary.destroy_all
Day.destroy_all
Content.destroy_all

puts " - Starting to create Itineraries -"

# Seed for itinerary
5.times do
  # Selecting employee from user db
  employee = User.find_by(admin: true)
  client = User.where(admin: false).sample
  # Selecting client from user db
  # Creating a variable with a location in Japan
  location = ["Tokyo", "Kyoto", "Hokkaido", "Okinawa", "Nagoya", "Osaka"].sample
  # Randomly generates a number of days
  days_number = rand(1..15)
  # Createing itinerary
  puts " - #1/5: #{days_number} in #{location}"

  itinerary = Itinerary.create!(name: "#{days_number} Days in #{location}",
                                location: location,
                                status: rand(0..3),
                                client: client,
                                employee: employee)

  # Generate stay, restuarants, activities
  days_number.times do |day_number|
    # Creating a Day db
    day = Day.create!(number: day_number, itinerary: itinerary)
    puts " - Day #{day_number}:"

    # Generate stay

    stay = Content.new(name: accomodation(location),
                        price: rand(15_000..100_000),
                        location: location,
                        category: "accommodation",
                        rating: rand(1..5),
                        description: Faker::Lorem.paragraph(sentence_count: 2),
                        api: "",
                        day: day,
                        status: rand(0..3))
    stay.save!
    puts "   Stay: #{Content.last.name}"

    # Generate restuarant for lunch
    lunch = Content.new(name: "#{Faker::Restaurant.name} (#{Faker::Restaurant.type})",
                         price: rand(1000..15_000),
                         location: location,
                         category: "lunch",
                         rating: rand(1..5),
                         description: Faker::Restaurant.description,
                         api: "",
                         day: day,
                         status: rand(0..3))
    lunch.save!
    puts "   Lunch: #{Faker::Restaurant.name} (#{Faker::Restaurant.type})"

    # Generate restuarant for dinner
    dinner = Content.new(name: "#{Faker::Restaurant.name} (#{Faker::Restaurant.type})",
                          price: rand(5000..55_000),
                          location: location,
                          category: "dinner",
                          rating: rand(1..5),
                          description: Faker::Lorem.paragraph(sentence_count: 2),
                          api: "",
                          day: day,
                          status: rand(0..3))
    dinner.save!
    puts "   Dinner: #{Faker::Restaurant.name} (#{Faker::Restaurant.type})"

    # Generate morning activity
    morning_activity = Content.new(name: "#{Faker::Hobby.activity} with #{Faker::JapaneseMedia::StudioGhibli.character}",
                                    price: rand(1000..15_000),
                                    location: location,
                                    category: "morning_activity",
                                    rating: rand(1..5),
                                    description: Faker::Lorem.paragraph(sentence_count: 2),
                                    api: "",
                                    day: day,
                                    status: rand(0..3))

    morning_activity.save!
    puts "   Morning Activity: #{Faker::Hobby.activity} with #{Faker::JapaneseMedia::StudioGhibli.character}"

    # Generate afternoon activity
    afternoon_activity = Content.new(name: "#{Faker::Hobby.activity} at #{Faker::Movies::StarWars.planet}",
                                      price: rand(4000..25_000),
                                      location: location,
                                      category: "afternoon_activity",
                                      rating: rand(1..5),
                                      description: Faker::Lorem.paragraph(sentence_count: 2),
                                      api: "",
                                      day: day,
                                      status: rand(0..3))
    afternoon_activity.save!
    puts "   Afternoon Activity: #{Faker::Hobby.activity} with #{Faker::JapaneseMedia::StudioGhibli.character}"
  end
end
puts " - Number of itineraries created: #{Itinerary.count} -"
puts "--------------------------"
puts " - Seed done -"
