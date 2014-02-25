class FixTypeColumn < ActiveRecord::Migration
  def change
    rename_column :users, :type, :via
  end
end
