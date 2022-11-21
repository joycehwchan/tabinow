class CreateDays < ActiveRecord::Migration[7.0]
  def change
    create_table :days do |t|

      t.timestamps
    end
  end
end
