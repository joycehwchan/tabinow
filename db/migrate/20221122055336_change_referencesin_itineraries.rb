class ChangeReferencesinItineraries < ActiveRecord::Migration[7.0]
  def change
    remove_index :itineraries, :client_id
    remove_index :itineraries, :employee_id
    add_reference :itineraries, :user, index: true
  end
end
