ActiveAdmin.register Contact do
  menu(priority: 4)
  permit_params(:name, :phone, :phone_schedule, :email, 
                :address, :address_schedule, :lat, :lon)
end
