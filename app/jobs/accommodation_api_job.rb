class AccommodationApiJob < ApplicationJob
  queue_as :default

  def perform(itineraries_params, min_price_generator, max_price_generator, itinerary, category)
    accommodations = AccommodationApiService.new(itineraries_params)
    accommodations.number_people = 2
    accommodations.price_from = min_price_generator / 2
    accommodations.price_to = max_price_generator / 2
    accommodations.start_date = itinerary.start_date
    accommodations.end_date = itinerary.end_date

    begin
      accommodations_results = accommodations.call
      accommodation = accommodations_results.sample
    rescue
      retry
    end

    accommodation_details = AccommodationDetailsApiService.new(accommodation["id"])
    accommodation_details = accommodation_details.call
    accommodation = Content.new(name: accommodation["name"],
                                price: accommodation["price"]["lead"]["amount"],
                                category:,
                                rating: accommodation["reviews"]["score"],
                                api: "",
                                status: 0)
    accommodation.location = accommodation_details["location"]["address"]["addressLine"]
    accommodation.description = accommodation_details["tagline"]
    if accommodation.save!
      Category.last.update!(sub_category: "Hotel")
    else
      # accommodation Failed
    end
  end
end
