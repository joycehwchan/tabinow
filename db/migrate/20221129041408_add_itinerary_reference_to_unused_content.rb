class AddItineraryReferenceToUnusedContent < ActiveRecord::Migration[7.0]
  def change
    add_reference :unused_contents, :itinerary, index: true
  end
end
