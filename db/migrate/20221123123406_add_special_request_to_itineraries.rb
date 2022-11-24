class AddSpecialRequestToItineraries < ActiveRecord::Migration[7.0]
  def change
    add_column :itineraries, :special_request, :text
  end
end
