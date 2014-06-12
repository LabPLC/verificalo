# -*- coding: utf-8 -*-
include ActiveAdminHelper

ActiveAdmin.register_page 'Dashboard' do

  menu priority: 1, label: 'Estadisticas'

  content title: 'Inicio' do
    columns do
      column do
        panel 'Usuarios' do
          render :partial => 'users'
        end
      end
      column do
        panel 'Avisos' do
          render :partial => 'notices'          
        end
      end
      column do
        panel 'Medios' do
          render :partial => 'vias'
        end
      end
    end
  end
end
