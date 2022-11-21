class CreateItineraries < ActiveRecord::Migration[7.0]
  def change
    create_table :itineraries do |t|
      t.string :name
      t.references :employee, foreign_key: { to_table: 'users' }
      t.references :client, foreign_key: { to_table: 'users' }
      t.integer :status
      t.string :location
      t.timestamps
    end
  end
end
