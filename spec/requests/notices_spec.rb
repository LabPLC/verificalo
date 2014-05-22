# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'notices sign up' do
  subject { page }
  
  describe 'home' do
    before { visit avisos_path }
    it { should have_button('Correo electrónico') }
    it { should have_button('Llamada telefónica') }

    describe 'navbar' do
      it { should have_link('Información', href: root_path) }
      it { should have_link('Avisos', href: avisos_path) }
      it { should have_link('Respuestas', href: respuestas_path) }
      it { should have_link('Mi suscripción', href: '#') }
      it { should have_link('Acerca', href: acerca_path) }
    end
    
    describe 'via email', :js => true do
      before { click_button('Correo electrónico') }
      it { should have_field('user[plate]') }
      it { should have_field('email[address]') }
      it { should have_field('user[verificacion]', :checked) }
      it { should have_field('user[adeudos]', :checked) }
      it { should have_field('user[no_circula_weekday]', :unchecked) }
      it { should have_field('user[no_circula_weekend]', :checked) }
      it { should have_button('Continuar') }
      describe 'post' do
        before do
          fill_in('user[plate]', with: FactoryGirl.generate(:plate))
          fill_in('email[address]', with: FactoryGirl.generate(:address))
          click_button('Continuar') 
        end
        it { should have_css('div.alert-info', 
                             :text => /confirmar(.*)visitando la dirección/i) }
      end
    end

    describe 'via phone', :js => true do
      before { click_button('Llamada telefónica') }
      it { should have_field('user[plate]') }
      it { should have_field('phone[number]') }
      it { should have_field('phone[cellphone]') }
      it { should have_field('user[verificacion]', :checked) }
      it { should have_field('user[adeudos]', :checked) }
      it { should have_field('user[no_circula_weekday]', :unchecked) }
      it { should have_field('user[no_circula_weekend]', :checked) }
      it { should have_field('phone[morning]', :checked) }
      it { should have_field('phone[afternoon]', :checked) }
      it { should have_field('phone[night]', :unchecked) }
      it { should have_button('Continuar') }
      describe 'post' do
        before do
          fill_in('user[plate]', with: FactoryGirl.generate(:plate))
          fill_in('phone[number]', with: FactoryGirl.generate(:number))
          click_button('Continuar') 
        end
        it { should have_css('div.alert-info', 
                             :text => /confirmar(.*)llamada telefonica/i) }
      end
    end
  end
  
  describe 'confirm user email' do
    before do
      @email = FactoryGirl.create(:email)
      @user = @email.user
      visit aviso_path(@user.id)
    end
    it { should have_css('div.alert-success', 
                         :text => /suscripción(.*)confirmada/i) }
  end

end
