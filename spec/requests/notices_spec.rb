# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'notices views' do
  subject { page }
  
  describe 'home' do
    before { visit recordatorios_path }

    # navbar
    it { should have_link('Información', href: root_path) }
    it { should have_link('Recordatorios', href: recordatorios_path) }
    it { should have_link('Preguntas y respuestas', href: respuestas_path) }
    # footer
    it { should have_link('Acerca de Verifícalo', href: acerca_path) }
    it { should have_link('Contáctanos', href: 'mailto:contacto@verificalo.mx') }
    it { should have_link('Código para la Ciudad de México', href: 'http://codigo.labplc.mx') }
    # content
    it { should have_field('user[plate]') }
    it { should have_field('user[verificacion]', :checked) }
    it { should have_field('user[adeudos]', :checked) }
    it { should have_field('user[no_circula_weekday]', :checked) }
    it { should have_field('user[no_circula_weekend]', :checked) }
    # it { should have_field('Correo electrónico') }
    # it { should have_field('Llamada telefónica') }
    
    # describe 'via email', :js => true do
      # before { choose('Correo electrónico') }
      it { should have_field('email[address]') }
      it { should have_button('Suscribirse') }
      describe 'submit' do
        before do
          fill_in('user[plate]', with: FactoryGirl.generate(:plate))
          fill_in('email[address]', with: FactoryGirl.generate(:address))
          click_button('Suscribirse') 
        end
        it { should have_content(/visita la página web que te enviamos/i) }
      end
    # end

  #   describe 'via phone', :js => true do
  #     before { choose('Llamada telefónica') }
  #     it { should have_field('phone[number]') }
  #     it { should have_field('phone[cellphone]') }
  #     it { should have_field('phone[morning]', :checked) }
  #     it { should have_field('phone[afternoon]', :checked) }
  #     it { should have_field('phone[night]', :unchecked) }
  #     it { should have_button('Suscribirse') }
  #     describe 'submit' do
  #       before do
  #         fill_in('user[plate]', with: FactoryGirl.generate(:plate))
  #         fill_in('phone[number]', with: FactoryGirl.generate(:number))
  #         choose('Teléfono celular')
  #         click_button('Suscribirse')
  #       end
  #       it { should have_content(/durante la llamada (.+) debes confirmar/i) }
  #     end
  #   end
  end
  
  describe 'confirm user email' do
    before do
      @email = FactoryGirl.create(:email)
      @user = @email.user
      visit user_path(@user.id)
    end
    it { should have_content(/tu suscripción esta confirmada/i) }
  end

end
