class CreateVerificentros < ActiveRecord::Migration
  def change
    create_table :verificentros do |t|
      t.integer :number, null: false
      t.string :name, null: false
      t.text :address, null: false
      t.integer :delegacion_id, null: false
      t.string :phone
      t.float :lat, null: false
      t.float :lon, null: false
      t.timestamps
    end
  end
end
