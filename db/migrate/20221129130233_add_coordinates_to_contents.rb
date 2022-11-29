class AddCoordinatesToContents < ActiveRecord::Migration[7.0]
  def change
    add_column :contents, :latitude, :float
    add_column :contents, :longitude, :float
  end
end
