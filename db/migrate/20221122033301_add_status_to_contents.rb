class AddStatusToContents < ActiveRecord::Migration[7.0]
  def change
    add_column :contents, :status, :integer
  end
end
