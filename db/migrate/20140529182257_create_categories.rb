class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :url, null: false
      t.string :name, null: false
      t.integer :order, null: false, default: 1
      t.timestamps
    end
  end
end
