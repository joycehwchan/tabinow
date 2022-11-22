# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Seed for clients
5.times do
  # Creating client:
  client = User.new(name: Faker::FunnyName.two_word_name,
                    email: Faker::Internet.safe_email,
                    password: "Password123",
                    phonenumber: Faker::PhoneNumber.cell_phone_in_e164)
  client.create!

  # Adding address to client:
  address = Address.new(street: Faker::Address.street_address,
                        street_two: Faker::Address.secondary_address,
                        zipcode: Faker::Address.zip_code,
                        city: Faker::Address.city,
                        country: Faker::Address.country,
                        user_id: client)
  address.create!
end

# Seed for itinerary
5.times do
  # Selecting employee from user db
  employee = User.where("admin == ? LIMIT 1, true")
  # Selecting client from user db
  client = User.where("admin == ? LIMIT 1, false")
  # Creating a variable with a location in Japan
  location = ["Tokyo", "Kyoto", "Hokkaido", "Okinawa", "Nagoya", "Osaka"].sample
  # Randomly generates a number of days
  days_number = rand(1..15)
  # Createing itinerary
  itinerary = Itinerary.create!(name: "#{days_number} in #{location}",
                                location: location,
                                status: rand(0..3),
                                client_id: client,
                                employee_id: employee)
  # Creating a Day db
  Day.create!(days: days_number, itinerary_id: itinerary)

  # Generate stay, restuarants, activities
  days_number.times do |day|
    # Generate stay
    stay_name = Faker::Games::SuperMario.character
    stay_type = ["Hotel", "Hostel", "Ryokan", "Camping Ground"].sample
    stay = Contents.new(name: "#{stay_name}'s #{stay_type}",
                        price: rand(15_000..100_000),
                        location: location,
                        category: "stay",
                        rating: rand(1..5),
                        description: Faker::Lorem.paragraph(sentence_count: 2),
                        api_id: rand(1..5),
                        day_id: day,
                        status: rand(0..3))
    stay.create!

    # lunch_restaurant_name = Faker::JapaneseMedia::StudioGhibli.character
    # Generate restuarant for lunch
    lunch = Contents.new(name: "#{Faker::Restaurant.name} (#{Faker::Restaurant.type})",
                         price: rand(1000..15_000),
                         location: location,
                         category: "lunch",
                         rating: rand(1..5),
                         description: Faker::Restaurant.description,
                         api_id: rand(1..5),
                         day_id: day,
                         status: rand(0..3))
    lunch.create!

    # Generate restuarant for dinner
    dinner = Contents.new(name: "#{Faker::Restaurant.name} (#{Faker::Restaurant.type})",
                          price: rand(5000..55_000),
                          location: location,
                          category: "dinner",
                          rating: rand(1..5),
                          description: Faker::Lorem.paragraph(sentence_count: 2),
                          api_id: rand(1..5),
                          day_id: day,
                          status: rand(0..3))
    dinner.create!

    # Generate morning activity
    morning_activity = Contents.new(name: "#{Faker::Hobby.activity} with #{Faker::JapaneseMedia::StudioGhibli.character}",
                                    price: rand(1000..15_000),
                                    location: location,
                                    category: "morning_activity",
                                    rating: rand(1..5),
                                    description: Faker::Lorem.paragraph(sentence_count: 2),
                                    api_id: rand(1..5),
                                    day_id: day,
                                    status: rand(0..3))
    morning_activity.create!

    # Generate afternoon activity
    afternoon_activity = Contents.new(name: "#{Faker::Sports.unusual_sport} at #{Faker::Movies::StarWars.planet}",
                                      price: rand(4000..25_000),
                                      location: location,
                                      category: "afternoon_activity",
                                      rating: rand(1..5),
                                      description: Faker::Lorem.paragraph(sentence_count: 2),
                                      api_id: rand(1..5),
                                      day_id: day,
                                      status: rand(0..3))
    afternoon_activity.create!
  end
end
