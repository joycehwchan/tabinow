class AddCategoryToContents < ActiveRecord::Migration[7.0]
  def change
    add_reference :contents, :category, index: true
  end
end
