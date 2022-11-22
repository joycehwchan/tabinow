class ChangeDataTypeForPhone < ActiveRecord::Migration[7.0]
  def change
    change_column(:users, :phone, :string)
  end
end
