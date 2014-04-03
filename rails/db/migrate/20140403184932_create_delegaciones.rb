class CreateDelegaciones < ActiveRecord::Migration
  def change
    create_table :delegaciones do |t|
      t.string :url, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
