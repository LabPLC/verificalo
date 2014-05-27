ActiveAdmin.register Verificentro do
  menu(priority: 1)
  permit_params(:number, :name, :address, :delegacion_id, :phone,
                :lat, :lon)
end
