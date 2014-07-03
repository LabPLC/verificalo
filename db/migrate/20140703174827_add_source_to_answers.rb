class AddSourceToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :source, :text, default: nil
  end
end
