class RenameNameToTitleInItineraries < ActiveRecord::Migration[7.0]
  def change
    rename_column :itineraries, :name, :title
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
