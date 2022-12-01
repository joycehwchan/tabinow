class RemoveSpecialRequestFromItineraries < ActiveRecord::Migration[7.0]
  def change
    remove_column :itineraries, :special_request
  end
end
