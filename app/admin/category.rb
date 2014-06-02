ActiveAdmin.register Category do
  menu(priority: 5)
  permit_params(:url, :name, :order)
end
