class AddSuspendedToVerificentros < ActiveRecord::Migration
  def change
    add_column :verificentros, :suspended, :boolean, null: false, default: false
  end
end
