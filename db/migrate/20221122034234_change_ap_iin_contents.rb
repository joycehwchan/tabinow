class ChangeApIinContents < ActiveRecord::Migration[7.0]
  def change
    remove_column :contents, :api_id
    add_column :contents, :api, :string
  end
end
