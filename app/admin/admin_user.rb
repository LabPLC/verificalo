# -*- coding: utf-8 -*-
ActiveAdmin.register AdminUser, as: 'Administradores' do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    column 'Correo electrónico', :email
    column 'Último acceso', :current_sign_in_at
    column 'Accesos', :sign_in_count
    actions
  end

  filter :email

  form do |f|
    f.inputs do
      f.input :email, label: 'Correo electrónico'
      f.input :password, label: 'Contraseña'
      f.input :password_confirmation, label: 'Confirmación de contraseña'
    end
    f.actions
  end
end
