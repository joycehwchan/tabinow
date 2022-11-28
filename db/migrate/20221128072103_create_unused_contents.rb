class CreateUnusedContents < ActiveRecord::Migration[7.0]
  def change
    create_table :unused_contents do |t|
      t.string :name
      t.integer :price
      t.string :location
      t.string :description
      t.string :api
      t.string :rating

      t.timestamps
    end
  end
end
