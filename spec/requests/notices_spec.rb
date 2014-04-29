# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Notices" do
  subject { page }

  describe 'home' do
    before { visit avisos_path }
    it { should have_content('¿Por qué medio desea recibir sus avisos?') }
    it { should have_button('Correo electrónico') }
    it { should have_button('Llamada telefónica') }
  
    describe 'via email', :js => true do
      before { click_button('Correo electrónico') }
      it { should have_content('¿Cual es la placa de su auto y su dirección de correo electrónico?') }
      it { should have_content('¿Qué avisos desea recibir sobre su auto?') }
      it { should have_button('Continuar') }

      describe 'post with invalid params' do
        before { 
          fill_in('user[plate]', with: 'abcdefghijklmnopqrstuvwxyz')
          fill_in('user[destination]', with: 'none@none')
          uncheck('settings[VERIFICACION]')
          uncheck('settings[ADEUDOS]')
          uncheck('settings[NO_CIRCULA_WEEKDAY]')
          uncheck('settings[NO_CIRCULA_WEEKEND]')
          click_button('Continuar')
        }
        it { should have_content('La placa que ingreso no es valida.') }
        it { should have_content('El correo electrónico que ingreso no es valido.') }
        it { should_not have_content('Debe seleccionar por lo menos un aviso.') }
        it { should have_button('Continuar') }        
      end
      
      describe 'post with invlaid plate' do
        before { 
          fill_in('user[plate]', with: 'abdefghijklmnopqrstuvwxyz')
          fill_in('user[destination]', with: 'none@none.com')
          click_button('Continuar') 
        }
        it { should have_content('La placa que ingreso no es valida.') }
        it { should_not have_content('El correo electrónico que ingreso no es valido.') }
        it { should_not have_content('Debe seleccionar por lo menos un aviso.') }
        it { should have_button('Continuar') }        
      end
      
      describe 'post with invlaid email' do
        before { 
          fill_in('user[plate]', with: '436per')
          fill_in('user[destination]', with: 'none@none')
          click_button('Continuar') 
        }
        it { should_not have_content('La placa que ingreso no es valida.') }
        it { should have_content('El correo electrónico que ingreso no es valido.') }
        it { should_not have_content('Debe seleccionar por lo menos un aviso.') }
        it { should have_button('Continuar') }        
      end

      describe 'post without settings' do
        before { 
          fill_in('user[plate]', with: '436per')
          fill_in('user[destination]', with: 'none@none.com')
          uncheck('settings[VERIFICACION]')
          uncheck('settings[ADEUDOS]')
          uncheck('settings[NO_CIRCULA_WEEKDAY]')
          uncheck('settings[NO_CIRCULA_WEEKEND]')
          click_button('Continuar') 
        }
        it { should_not have_content('La placa que ingreso no es valida.') }
        it { should_not have_content('El correo electrónico que ingreso no es valido.') }
        it { should have_content('Debe seleccionar por lo menos un aviso.') }
        it { should have_button('Continuar') }        
      end

      describe 'post' do
        before { 
          fill_in('user[plate]', with: '436per')
          fill_in('user[destination]', with: 'none@none.com')
          click_button('Continuar') 
        }
        it { should have_content('Debe confirmar su suscripción a los avisos de su auto') }
      end      

    end

  end

end
