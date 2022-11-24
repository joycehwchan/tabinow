class ActivitiesApiService

  def initialize(date_from, date_to, number_people, price_from, price_to)
    @date_from = date_from
    @date_to = date_to
    @number_people = number_people
    @price_from = price_from
    @price_to = price_to
  end

  def call
    # Calls the API
  end



end




# gmaps_API_key = "xxx"
# url = URI("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=tokyo&inputtype=textquery&fields=formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry&key=#{gmaps_API_key}")

# https = Net::HTTP.new(url.host, url.port)
# https.use_ssl = true

# request = Net::HTTP::Get.new(url)

# response = https.request(request)
# results = JSON.parse(response.body)

# # The lat and long for the location
# results = results["candidates"].first["geometry"]["location"]
# lat = results["lat"]
# lng = results["lng"]

# activity_types = ["amusement_park", "aquarium", "art_gallery", "museum", "tourist_attraction", "zoo"]

# # url = URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat}%2C#{lng}&radius=15000&type=tourist_attraction&key=AIzaSyAo67kwsWD0msXs1I4x2RP8Pw99izyCoJE")

# activity_types.each do |activity_type|
#   url = URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat}%2C#{lng}&radius=50000&type=#{activity_type}&key=#{gmaps_API_key}")

#   https = Net::HTTP.new(url.host, url.port)
#   https.use_ssl = true

#   request = Net::HTTP::Get.new(url)

#   response = https.request(request)
#   results = JSON.parse(response.body)["results"]
#   puts "Generating: #{activity_type}"

#   results.first(10).each do |result|
#     puts result["name"]
#   end

#   puts "##################"

# end
