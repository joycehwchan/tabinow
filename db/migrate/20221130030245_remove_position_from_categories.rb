class RemovePositionFromCategories < ActiveRecord::Migration[7.0]
  def change
    remove_column :categories, :position
  end
end
