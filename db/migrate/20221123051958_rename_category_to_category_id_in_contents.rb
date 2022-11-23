class RenameCategoryToCategoryIdInContents < ActiveRecord::Migration[7.0]
  def change
    remove_column :contents, :category
    # add_reference :contents, :category, index: true
  end
end
