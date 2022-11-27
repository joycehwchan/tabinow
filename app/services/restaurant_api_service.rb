require 'uri'
require 'net/http'
require 'openssl'

class RestaurantApiService
  attr_accessor :location, :keyword, :price

  def initialize(attr = {})
    @location = attr[:location]
    @keyword = attr[:keyword]
    @price = attr[:price]
  end

  def call
    # Calls the API
    url = URI("https://api.yelp.com/v3/businesses/search?location=#{@location},Japan&term=#{@keyword}&price=#{@price}&limit=50")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request['Authorization'] = "Bearer #{ENV.fetch('YELP_API_KEY')}"

    begin
      response = http.request(request)

      restuarants = JSON.parse(response.body)["businesses"]
    rescue JSON::ParserError
      retry
    end
    return restuarants
  end
end
