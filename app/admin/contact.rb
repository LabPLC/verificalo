# -*- coding: utf-8 -*-
ActiveAdmin.register Contact, as: 'Contactos' do
  menu(priority: 4)

  permit_params(:name, :phone, :email, :address, :lat, :lon)

  index do
    selectable_column
    column 'Nombre', :name
    column 'Teléfono', :phone
    column 'Correo electrónico', :email
    actions
  end

  filter :name, label: 'Nombre'

  form do |f|
    f.inputs do
      f.input :name, label: 'Nombre'
      f.input :phone, label: 'Teléfono'
      f.input :email, label: 'Correo Electrónico'
      f.input :address, label: 'Dirección'
      f.input :lat, label: 'Latitud', hint: 'En grados decimales'
      f.input :lon, label: 'Longitud', hint: 'En grados decimales'
    end
    f.actions
  end
end
