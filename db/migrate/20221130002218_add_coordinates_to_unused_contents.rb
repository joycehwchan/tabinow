class AddCoordinatesToUnusedContents < ActiveRecord::Migration[7.0]
  def change
    add_column :unused_contents, :latitude, :float
    add_column :unused_contents, :longitude, :float
  end
end
