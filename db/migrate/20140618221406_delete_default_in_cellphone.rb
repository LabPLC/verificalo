class DeleteDefaultInCellphone < ActiveRecord::Migration
  def change
    change_column_default('phones', 'cellphone', nil)
  end
end
