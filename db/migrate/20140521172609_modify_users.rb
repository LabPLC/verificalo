class ModifyUsers < ActiveRecord::Migration
  def change
    remove_column :users, :via
    remove_column :users, :destination
    add_column :users, :adeudos, :boolean, null: false, default: false
    add_column :users, :verificacion, :boolean, null: false, default: false
    add_column :users, :no_circula_weekday, :boolean, null: false, default: false
    add_column :users, :no_circula_weekend, :boolean, null: false, default: false
  end
end
