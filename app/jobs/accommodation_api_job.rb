class AccommodationApiJob < ApplicationJob
  queue_as :default

  def perform(itinerary, min_price_generator, max_price_generator, category)
    accommodations = AccommodationApiService.new(itinerary)
    accommodations.number_people = 2
    accommodations.price_from = min_price_generator / 2
    accommodations.price_to = max_price_generator / 2
    accommodations.start_date = itinerary.start_date
    accommodations.end_date = itinerary.end_date

    begin
      accommodations_results = accommodations.call
      accommodation_selected = accommodations_results.sample
    rescue
      retry
    end

    accommodation_details_selected = AccommodationDetailsApiService.new(accommodation_selected["id"])
    accommodation_details = accommodation_details_selected.call
    accommodation = Content.new(name: accommodation_selected["name"],
                                price: accommodation_selected["price"]["lead"]["amount"],
                                category:,
                                rating: accommodation_selected["reviews"]["score"] / 2,
                                api: accommodation_selected["id"],
                                status: 0)
    accommodation.location = accommodation_details_selected["location"]["address"]["addressLine"]
    accommodation.description = accommodation_details_selected["tagline"]
    if accommodation.save!
      Category.last.update!(sub_category: "Hotel")

      # Getting the image
      property_image = URI.open(accommodation_details_selected["propertyImage"]["image"]["url"])
      accommodation.image.attach(io: property_image, filename: "property_#{accommodation_selected['id']}.png", content_type: "image/png")
      accommodation.save!
    else
      # accommodation Failed
    end
  end
end
