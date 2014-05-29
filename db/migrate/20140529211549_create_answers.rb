class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :category_id, null: false
      t.integer :contact_id, default: nil
      t.string :url, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.timestamps
    end
  end
end
