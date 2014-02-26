class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.uuid :user_id, null: false
      t.string :setting, null: false
      t.boolean :active, null: false, default: true
      t.timestamps
    end
  end
end
