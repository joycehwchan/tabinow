require "open-uri"

class AccommodationApiJob < ApplicationJob
  queue_as :default

  def perform(itinerary, min_price_generator, max_price_generator, category_array)
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

    category_array.each do |category|
      accommodation_details_selected = AccommodationDetailsApiService.new(accommodation_selected["id"])
      accommodation_details = accommodation_details_selected.call
      accommodation = Content.new(name: accommodation_selected["name"],
                                  price: accommodation_selected["price"]["lead"]["amount"],
                                  category:,
                                  rating: accommodation_selected["reviews"]["score"] / 2,
                                  api: accommodation_details["summary"]["id"],
                                  status: 0)
      accommodation.location = accommodation_details["summary"]["location"]["address"]["addressLine"]
      accommodation.description = accommodation_details["summary"]["tagline"]
      # Getting the image
      if accommodation_details["propertyGallery"]["images"][0]["image"]["url"].present?
        property_image = URI.parse(accommodation_details["propertyGallery"]["images"][0]["image"]["url"]).open
        accommodation.image.attach(io: property_image, filename: "property_#{accommodation_details['summary']['id']}.png", content_type: "image/png")
        Category.last.update!(sub_category: "Hotel") if accommodation.save!
      else
        Category.last.update!(sub_category: "Hotel") if accommodation.save!
      end
    end
  end
end
