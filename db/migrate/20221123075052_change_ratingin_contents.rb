class ChangeRatinginContents < ActiveRecord::Migration[7.0]
  def change
    remove_column :contents, :rating
    add_column :contents, :rating, :string
  end
end
