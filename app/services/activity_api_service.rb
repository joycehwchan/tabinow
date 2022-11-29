class ActivityApiService

  def initialize(attr = {})
    @location = attr[:location]
    @keyword = attr[:keyword]
    @number_people = attr[:number_people]
    @price = attr[:price]
  end

  def call
    # Calls the API
    url = URI("https://api.yelp.com/v3/businesses/search?location=#{@location},Japan&term=#{@keyword}&price=#{@price}&sort_by=review_count&limit=50")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request['Authorization'] = "Bearer #{ENV.fetch('YELP_API_KEY')}"

    begin
      response = http.request(request)

      activity = JSON.parse(response.body)["businesses"]
    # rescue JSON::ParserError
    #   retry
    end
    return activity
  end
end
