class CreateRelatedAnswers < ActiveRecord::Migration
  def change
    create_table :related_answers do |t|
      t.integer :answer_id
      t.integer :related_id

      t.timestamps
    end
  end
end
