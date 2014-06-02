class AddRelatedToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :related_1_id, :integer, default: nil
    add_column :answers, :related_2_id, :integer, default: nil
    add_column :answers, :related_3_id, :integer, default: nil
    add_column :answers, :related_4_id, :integer, default: nil
    add_column :answers, :related_5_id, :integer, default: nil
  end
end
