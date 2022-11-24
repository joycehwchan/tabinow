class AddArchivedAndStartDateAndEndDateToItineraries < ActiveRecord::Migration[7.0]
  def change
    add_column :itineraries, :archived, :boolean , default: false
    add_column :itineraries, :start_date, :date
    add_column :itineraries, :end_date, :date
  end
end
