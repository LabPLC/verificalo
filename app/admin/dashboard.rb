# -*- coding: utf-8 -*-
include ActiveAdminHelper

ActiveAdmin.register_page 'Dashboard' do

  menu priority: 1, label: 'Estadisticas'

  stats = { 
    users: { 
      active: User.are_active.count,
      wo_confirm: User.where(confirmed_at: nil).count,
      declined: User.where.not(confirmed_at: nil).where.not(declined_at: nil).count,
      total: User.count },
    notices: {
      verificacion: User.are_active.where(verificacion: true).count,
      adeudos: User.are_active.where(adeudos: true).count,
      no_circula_weekday: User.are_active.where(no_circula_weekday: true).count,
      no_circula_weekend: User.are_active.where(no_circula_weekend: true).count,
      total: User.are_active.count },
    via: {
      email: User.are_active.joins(:email).count,
      phone: User.are_active.joins(:phone).count,
      total: User.are_active.count
    }
  }

  content title: 'Inicio' do
    columns do
      column do
        panel 'Usuarios' do
          table do
            thead do
              th 'Estatus'
              th '#'
              th '%'
            end
            tr do
              td 'Activos'
              td stats[:users][:active]
              td pct(stats[:users][:active], stats[:users][:total])
            end
            tr do
              td 'Sin confirmar'
              td stats[:users][:wo_confirm]
              td pct(stats[:users][:wo_confirm], stats[:users][:total])
            end
            tr do
              td 'Cancelados'
              td stats[:users][:declined]
              td pct(stats[:users][:declined], stats[:users][:total])
            end
            tr do
              td 'Total usuarios'
              td stats[:users][:total]
              td pct(stats[:users][:total], stats[:users][:total])
            end
          end
        end
      end
      column do
        panel 'Avisos' do
          table do
            thead do
              th 'Tipo'
              th '#'
              th '%'
            end
            tr do
              td 'Verificación'
              td stats[:notices][:verificacion]
              td pct(stats[:notices][:verificacion], stats[:notices][:total])
            end
            tr do
              td 'Adeudos'
              td stats[:notices][:adeudos]
              td pct(stats[:notices][:adeudos], stats[:notices][:total])
            end
            tr do
              td 'Hoy no circula semanal'
              td stats[:notices][:no_circula_weekday]
              td pct(stats[:notices][:no_circula_weekday], stats[:notices][:total])
            end
            tr do
              td 'Hoy no circula sabatino'
              td stats[:notices][:no_circula_weekend]
              td pct(stats[:notices][:no_circula_weekend], stats[:notices][:total])
            end
            tr do
              td 'Total usuarios activos'
              td stats[:notices][:total]
              td pct(stats[:notices][:total], stats[:notices][:total])
            end
          end
        end
      end
      column do
        panel 'Medio' do
          table do
            thead do
              th 'Via'
              th '#'
              th '%'
            end
            tr do
              td 'Correo electrónico'
              td stats[:via][:email]
              td pct(stats[:via][:email], stats[:via][:total])
            end
            tr do
              td 'Llamada telefónica'
              td stats[:via][:phone]
              td pct(stats[:via][:phone], stats[:via][:total])
            end
            tr do
              td 'Total usuarios activos'
              td stats[:via][:total]
              td pct(stats[:via][:total], stats[:via][:total])
            end
          end
        end
      end
    end
  end
end
