class AddMinBudgetAndMaxBudgetToItineraries < ActiveRecord::Migration[7.0]
  def change
    add_column :itineraries, :min_budget, :integer
    add_column :itineraries, :max_budget, :integer
  end
end
