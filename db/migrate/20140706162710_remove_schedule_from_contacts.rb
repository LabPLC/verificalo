class RemoveScheduleFromContacts < ActiveRecord::Migration
  def change
    remove_column :contacts, :phone_schedule
    remove_column :contacts, :address_schedule
  end
end
