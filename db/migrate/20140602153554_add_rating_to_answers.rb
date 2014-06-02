class AddRatingToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :views, :integer, null: false, default: 0
    add_column :answers, :positive, :integer, null: false, default: 0
    add_column :answers, :negative, :integer, null: false, default: 0
  end
end
