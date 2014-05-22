class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :plate, limit: 14, null: false
      t.boolean :adeudos, null: false, default: false
      t.boolean :verificacion, null: false, default: false
      t.boolean :no_circula_weekday, null: false, default: false
      t.boolean :no_circula_weekend, null: false, default: false
      t.datetime :confirmed_at
      t.datetime :declined_at
      t.timestamps
    end
  end
end
