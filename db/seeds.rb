
puts " --- Seeds for TabiNow ---"
puts "--------------------------"
puts " - Removing old Users (with addresses) -"

User.destroy_all

puts " - Starting to create Users -"

# Creating Employee user:
employee = User.new(name: "TabiNowEmp",
                  email: "emp@tabinow.tours",
                  password: "Password123")
employee.save!

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
  employee = User.all.sample
  # Selecting client from user db
  # Creating a variable with a location in Japan
  location = ["Tokyo", "Kyoto", "Hokkaido", "Okinawa", "Nagoya", "Osaka"].sample
  # Randomly generates a number of days
  days_number = rand(1..15)
  # Createing itinerary
  puts " - #1/5: #{days_number} in #{location}"

  itinerary = Itinerary.create!(name: "#{days_number} in #{location}",
                                location: location,
                                status: rand(0..3),
                                user: employee)

  # Generate stay, restuarants, activities
  days_number.times do |day_number|
    # Creating a Day db
    day = Day.create!(number: day_number, itinerary: itinerary)
    puts " - Day #{day_number}:"

    # Generate stay
    stay_name = Faker::Games::SuperMario.character
    stay_type = ["Hotel", "Hostel", "Ryokan", "Camping Ground"].sample
    stay = Content.new(name: "#{stay_name}'s #{stay_type}",
                        price: rand(15_000..100_000),
                        location: location,
                        category: "stay",
                        rating: rand(1..5),
                        description: Faker::Lorem.paragraph(sentence_count: 2),
                        api: "",
                        day: day,
                        status: rand(0..3))
    stay.save!
    puts "   Stay: #{stay_name}'s #{stay_type}"

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
