class FixPlateLimit < ActiveRecord::Migration
  def change
    change_column :users, :plate, :string, :limit => 14
  end
end
