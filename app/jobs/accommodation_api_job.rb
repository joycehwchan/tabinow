require "open-uri"

class AccommodationApiJob < ApplicationJob
  queue_as :default

  def perform(itinerary, min_price_generator, max_price_generator, category_array)
    accommodations = AccommodationApiService.new(itinerary)
    # Temp hardcoded for number of people
    accommodations.number_people = 2
    # Setitng the min/max price
    accommodations.price_from = min_price_generator / 2
    accommodations.price_to = max_price_generator / 2
    # Setitng the start/end dates
    accommodations.start_date = itinerary.start_date
    accommodations.end_date = itinerary.end_date

    begin
      # Getting an array with matching accommodations
      accommodations_results = accommodations.call
      # Getitng a ranom accommodation from the array of results
      accommodation_selected = accommodations_results.sample
    # rescue
    #   retry
    end

    # Looping throught the category arrya (that belongs to each day)
    category_array.each do |category|
      # Getting some more specific info from the next API
      accommodation_details_selected = AccommodationDetailsApiService.new(accommodation_selected["id"])
      accommodation_details = accommodation_details_selected.call
      # Creating teh instance for the Accommodation
      accommodation = Content.new(name: accommodation_selected["name"],
                                  price: accommodation_selected["price"]["lead"]["amount"],
                                  location: accommodation_details["summary"]["location"]["address"]["addressLine"],
                                  category: category,
                                  description: accommodation_details["summary"]["tagline"],
                                  rating: accommodation_selected["reviews"]["score"] / 2,
                                  api: accommodation_details["summary"]["id"],
                                  status: 0)
      # Getting and savinf the the image to AS & Cloudinary
      # Checking if tehre is an image get in the API
      if accommodation_details["propertyGallery"]["images"][0]["image"]["url"].present?
        # Fetching teh image and saving it in ActiveStorage/Cloudinary
        property_image = URI.parse(accommodation_details["propertyGallery"]["images"][0]["image"]["url"]).open
        accommodation.image.attach(io: property_image,
                                   filename: "property_#{accommodation_details['summary']['id']}.png",
                                   content_type: "image/png")
      end
      # Updating the sub category for the category
      category.update!(sub_category: "Hotel") if accommodation.save!
    end

    accommodations_results.delete(accommodation_selected)

    accommodations_results.take(0).each do |accommodation|
      accommodation_details_selected = AccommodationDetailsApiService.new(accommodation["id"])
      accommodation_details = accommodation_details_selected.call
      # Loop and save
      unused_accommodation = UnusedContent.new(name: accommodation["name"],
                                              price: accommodation["price"]["lead"]["amount"],
                                              location: accommodation_details["summary"]["location"]["address"]["addressLine"],
                                              category_title: "Accommodation",
                                              category_sub_category: "Hotel",
                                              description: accommodation_details["summary"]["tagline"],
                                              rating: accommodation["reviews"]["score"] / 2,
                                              api: accommodation["id"],
                                              itinerary:)
      if accommodation_details["propertyGallery"]["images"][0]["image"]["url"].present?
        # Fetching teh image and saving it in ActiveStorage/Cloudinary
        property_image = URI.parse(accommodation_details["propertyGallery"]["images"][0]["image"]["url"]).open
        unused_accommodation.image.attach(io: property_image,
                                          filename: "property_#{accommodation["id"]}.png",
                                          content_type: "image/png")
      end
      unused_accommodation.save!
    end
  end
end
