class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :plate, limit: 12, null: false
      t.string :type, null: false
      t.string :destination, null: false
      t.datetime :confirmed_at
      t.datetime :declined_at
      t.timestamps
    end
  end
end
