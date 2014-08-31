# -*- coding: utf-8 -*-
ActiveAdmin.register Verificentro do
  menu(priority: 1)

  permit_params(:number, :name, :address, :delegacion_id, :phone, :lat, :lon, :suspended)

  index do
    selectable_column
    column 'Número', :number
    column 'Razón Social', :name
    column 'Dirección', :address
    column 'Delegación', :delegacion
    column 'Latitud', :lat
    column 'Longitud', :lon
    column 'Suspendido', :suspended
    actions
  end
  
  filter :number, label: 'Número'
  filter :delegacion, label: 'Delegación'
  filter :name, label: 'Razón Social'
  filter :suspended, label: 'Suspendido'

  form do |f|
    f.inputs do
      f.input :number, label: 'Número'
      f.input :name, label: 'Razón Social'
      f.input :address, label: 'Dirección'
      f.input :delegacion, label: 'Delegación'
      f.input :phone, label: 'Teléfono', hint: 'Para varios teléfonos separarlos con un espacio'
      f.input :lat, label: 'Latitud', hint: 'En grados decimales'
      f.input :lon, label: 'Longitud', hint: 'En grados decimales'
      f.input :suspended, label: 'Suspendido'
    end
    f.actions
  end
end
