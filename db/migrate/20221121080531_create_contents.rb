class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.string :category
      t.string :name
      t.integer :price
      t.string :location
      t.integer :rating
      t.string :description
      t.string :api_id
      t.timestamps
    end
  end
end
