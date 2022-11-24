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

    key = 'Bearer SxGC-lIGxglEDFDoPWQVvrfYG_dPbKKsf07_1lv4PPN8QHzYs9PAZSCPvbFONVRzRj4S-08QRXfRjvmhvoKdASJkWApQ_BSM3P037WPDuWvbvJ1knBFBu7Tv-7l9Y3Yx'
    request['Authorization'] = key

    response = http.request(request)

    restuarants = JSON.parse(response.body)["businesses"]

    return restuarants
  end
end
