class CreateUnusedCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :unused_categories do |t|
      t.string :title
      t.string :type
      t.string :sub_category

      t.timestamps
    end
  end
end
