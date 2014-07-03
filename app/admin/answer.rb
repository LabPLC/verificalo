# -*- coding: utf-8 -*-
ActiveAdmin.register Answer, as: 'Respuestas' do
  menu(priority: 2)

  permit_params(:category_id, :contact_id, :url, :title, :body, :source,
                :related_1_id, :related_2_id, :related_3_id, 
                :related_4_id, :related_5_id)

  index do
    selectable_column
    column 'Titulo', :title
    column 'URL', :url
    column 'Categoría', :category
    column 'Contacto', :contact
    column 'Visitas', :views
    #column 'Positivas', :positive
    #column 'Negativas', :negative
    actions
  end
  
  filter :title, label: 'Titulo'
  filter :category, label: 'Categoría'
  filter :contact, label: 'Contacto'
  
  form do |f|
    f.inputs do
      f.input :title, label: 'Titulo'
      f.input :url, label: 'URL'
      f.input :category, label: 'Categoría'
      f.input :contact, label: 'Contacto'
      f.input :body, label: 'Texto'
      f.input :source, as: :string, label: 'Fuente'
      f.input :related_1, label: 'Respuesta relacionada 1'
      f.input :related_2, label: 'Respuesta relacionada 2'
      f.input :related_3, label: 'Respuesta relacionada 3'
      f.input :related_4, label: 'Respuesta relacionada 4'
      f.input :related_5, label: 'Respuesta relacionada 5'
    end
    f.actions
  end
end
