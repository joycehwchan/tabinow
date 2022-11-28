class CreateUnusedContents < ActiveRecord::Migration[7.0]
  def change
    create_table :unused_contents do |t|
      t.string :name
      t.integer :price
      t.string :location
      t.string :description
      t.string :api
      t.string :rating
      t.string :category_title
      t.string :category_type
      t.string :category_sub_category

      t.timestamps
    end
  end
end
