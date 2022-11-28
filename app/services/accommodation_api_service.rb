require 'uri'
require 'net/http'
require 'openssl'

class AccommodationApiService
  attr_accessor :location, :start_date, :end_date, :number_people, :price_from, :price_to

  def initialize(attr = {})
    @location = attr[:location]
    @start_date = attr[:start_date]
    @end_date = attr[:end_date]
    @number_people = attr[:number_people]
    @price_from = attr[:price_from]
    @price_to = attr[:price_to]
  end

  def call
    # Calls the API for accommodation

    # The API URL to get the area code for the accommodation search (adding the location to the query)
    url = URI("https://hotels4.p.rapidapi.com/locations/v3/search?q=#{@location}%2C%20japan&locale=en_US&langid=1033&siteid=300000001")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # Adding the API-key
    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = '2ce7422325msh1413b85402383f0p1d4a08jsn506805417938'
    request["X-RapidAPI-Host"] = 'hotels4.p.rapidapi.com'

    begin
      # Making the API call
      response = http.request(request)
      # Converting the reponse body into JSON
      result = JSON.parse(response.body)
    rescue JSON::ParserError
      retry
    end
    # Getting the location id for the hotel seach
    search_location = result["sr"][0]["gaiaId"]
    # The API to get accommodations
    url = URI("https://hotels4.p.rapidapi.com/properties/v2/list")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # Adding the API-key
    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/json'
    request["X-RapidAPI-Key"] = ENV.fetch('HOTELS_API_KEY')
    request["X-RapidAPI-Host"] = 'hotels4.p.rapidapi.com'
    body = "{\n \"currency\": \"USD\",\n \"eapid\": 1,\n \"locale\": \"en_US\",\n \"siteId\": 300000001,\n \"destination\": {\n  \"regionId\": \"#{search_location}\"\n },\n \"checkInDate\": {\n  \"day\": #{@start_date.strftime('%-d')},\n  \"month\": #{@start_date.strftime('%_m')},\n  \"year\": #{@start_date.strftime('%Y')}\n },\n \"checkOutDate\": {\n  \"day\": #{@end_date.strftime('%-d')},\n  \"month\": #{@end_date.strftime('%_m')},\n  \"year\": #{@end_date.strftime('%Y')}\n },\n \"rooms\": [\n  {\n   \"adults\": #{@number_people}\n   }\n ],\n \"resultsStartingIndex\": 0,\n \"resultsSize\": 200,\n \"sort\": \"PRICE_LOW_TO_HIGH\",\n \"filters\": {\n  \"price\": {\n   \"max\": #{@price_to},\n   \"min\": #{@price_from}\n  }\n }\n}"
    # Sending the POST body with all the search params (including the location id fro above)
    request.body = body
    # Making the API call
    response = http.request(request)

    # Converting the reponse body into JSON
    result = JSON.parse(response.body)

    # Selecting the accommodations from the results
    search_accommodations = result["data"]["propertySearch"]["properties"]

    # Returning the results from the API
    return search_accommodations
  end
end
