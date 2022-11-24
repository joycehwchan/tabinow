class ActivityApiService

  def initialize(attr = {})
    @location = attr[:location]
    @keyword = attr[:keyword]
    @number_people = attr[:number_people]
    @price = attr[:price]
  end

  def call
    # Calls the API
  end

end
