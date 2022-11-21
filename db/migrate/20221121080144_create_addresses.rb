class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.integer :zipcode
      t.string :street
      t.string :city
      t.string :country
      t.string :user_id

      t.timestamps
    end
  end
end
