class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :title
      t.string :sub_category
      t.references :day, null: false, foreign_key: true
      t.timestamps
    end
  end
end
