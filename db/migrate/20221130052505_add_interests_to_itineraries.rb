class AddInterestsToItineraries < ActiveRecord::Migration[7.0]
  def change
    add_column :itineraries, :Interests, :string
  end
end
