class CreateItineraries < ActiveRecord::Migration[7.0]
  def change
    create_table :itineraries do |t|

      t.timestamps
    end
  end
end
