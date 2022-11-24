class AccomodationApiService
  def initialize(attr = {})
    @location = attr[:location]
    @date_from = attr[:date_from]
    @date_to = attr[:date_to]
    @number_people = attr[:number_people]
    @price_from = attr[:price_from]
    @price_to = attr[:price_to]
  end

  def call
    # Calls the API for accomodation

    # The API URL to get the area code for the accomodation search (adding the location to the query)
    url = URI("https://hotels4.p.rapidapi.com/locations/v3/search?q=#{@location}&locale=en_US&langid=1033&siteid=300000001")

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

    # The API to get accomodations
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
    request.body = "{\n \"currency\": \"USD\",\n \"eapid\": 1,\n \"locale\": \"en_US\",\n \"siteId\": 300000001,\n \"destination\": {\n  \"regionId\": \"#{search_location}\"\n },\n \"checkInDate\": {\n  \"day\": #{date_from.strftime('%d')},\n  \"month\": #{date_from.strftime('%m')},\n  \"year\": #{date_from.strftime('%Y')}\n },\n \"checkOutDate\": {\n  \"day\": #{date_to.strftime('%d')},\n  \"month\": #{date_to.strftime('%m')},\n  \"year\": #{date_to.strftime('%Y')}\n },\n \"rooms\": [\n  {\n   \"adults\": #{@number_people},\n   \"children\": [\n    {\n     \"age\": 0\n    },\n    {\n     \"age\": 0\n    }\n   ]\n  }\n ],\n \"resultsStartingIndex\": 0,\n \"resultsSize\": 200,\n \"sort\": \"PRICE_LOW_TO_HIGH\",\n \"filters\": {\n  \"price\": {\n   \"max\": #{@price_to},\n   \"min\": #{@price_from}\n  }\n }\n}"

    # Making the API call
    response = http.request(request)

    # Converting the reponse body into JSON
    result = JSON.parse(response.body)

    # Selecting the accomodations from the results
    search_accomodations = result["data"]["propertySearch"]["properties"]

    # Returning the results from the API
    return search_accomodations
  end
end
