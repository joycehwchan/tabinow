class CreateNames < ActiveRecord::Migration[7.0]
  def change
    create_table :names do |t|
      t.string :email
      t.integer :phone
      t.boolean :admin

      t.timestamps
    end
  end
end
