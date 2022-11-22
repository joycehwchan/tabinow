class AddEmailAndPhoneToItineraries < ActiveRecord::Migration[7.0]
  def change
    add_column :itineraries, :email, :string
    add_column :itineraries, :phone, :string
  end
end
