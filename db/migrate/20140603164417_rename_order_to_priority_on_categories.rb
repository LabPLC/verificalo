class RenameOrderToPriorityOnCategories < ActiveRecord::Migration
  def change
    rename_column :categories, :order, :priority
  end
end
