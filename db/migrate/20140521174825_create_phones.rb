class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.uuid :user_id, null: false
      t.string :number, null: false, limit: 10
      t.boolean :cellphone, null: false, default: false
      t.boolean :morning, null: false, default: false
      t.boolean :afternoon, null: false, default: false
      t.boolean :night, null: false, default: false
      t.timestamps
    end
  end
end
