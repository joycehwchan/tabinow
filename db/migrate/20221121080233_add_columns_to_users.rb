class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :integer
    add_column :users, :admin, :boolean, default: false
  end
end
