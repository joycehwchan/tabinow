require 'uri'
require 'net/http'
require 'openssl'

class AccommodationDetailsApiService
  attr_accessor :property_id

  def initialize(property_id)
    @property_id = property_id
  end

  def call
    url = URI("https://hotels4.p.rapidapi.com/properties/v2/detail")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/json'
    request["X-RapidAPI-Key"] = ENV.fetch('HOTELS_API_KEY')
    request["X-RapidAPI-Host"] = 'hotels4.p.rapidapi.com'
    request.body = "{
        \"currency\": \"USD\",
        \"eapid\": 1,
        \"locale\": \"en_US\",
        \"siteId\": 300000001,
        \"propertyId\": \"#{@property_id}\"
    }"

    begin
      # Making the API call
      response = http.request(request)

      # Converting the reponse body into JSON
      result = JSON.parse(response.body)
      rescue JSON::ParserError
      retry
    end
    # Selecting the accommodation from the results
    accommodation_details = result["data"]["propertyInfo"]["summary"]

    # Returning the results from the API
    return accommodation_details
  end
end
