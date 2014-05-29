class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.string :phone, default: nil
      t.string :phone_schedule, default: nil
      t.string :email, default: nil
      t.string :address, default: nil
      t.string :address_schedule, default: nil
      t.float :lat, default: nil
      t.float :lon, default: nil
      t.timestamps
    end
  end
end
