# -*- coding: utf-8 -*-
ActiveAdmin.register Category, as: 'Categorias' do
  menu(priority: 5)

  permit_params(:url, :name, :priority)

  index do
    selectable_column
    column 'Nombre', :name
    column 'URL', :url
    column 'Prioridad', :priority
    actions
  end

  filter :name, label: 'Nombre'

  form do |f|
    f.inputs do
      f.input :name, label: 'Nombre'
      f.input :url, label: 'URL'
      f.input :name, label: 'Prioridad', hint: 'Igual o mayor a 1'
    end
    f.actions
  end
end
