class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.uuid :user_id, null: false
      t.string :address, null: false
      t.timestamps
    end
  end
end
