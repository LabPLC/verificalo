# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'notices sign up' do
  subject { page }
  
  describe 'home' do
    before { visit avisos_path }
    it { should have_button('Correo electrónico') }
    it { should have_button('Llamada telefónica') }
    
    describe 'via email', :js => true do
      before { click_button('Correo electrónico') }
      it { should have_field('user[plate]') }
      it { should have_field('user[destination]') }
      it { should have_field('user[destination]') }
      it { should have_field('settings[VERIFICACION]', :checked) }
      it { should have_field('settings[ADEUDOS]', :checked) }
      it { should have_field('settings[NO_CIRCULA_WEEKDAY]', :unchecked) }
      it { should have_field('settings[NO_CIRCULA_WEEKEND]', :checked) }
      it { should have_button('Continuar') }
      describe 'post' do
        before do
          fill_in('user[plate]', with: FactoryGirl.generate(:plate))
          fill_in('user[destination]', with: FactoryGirl.generate(:email))
          click_button('Continuar') 
        end
        it { should have_css('div.alert-info', 
                             :text => /debe confirmar su suscripción/i) }
      end
      
    end
  end
  
  describe 'confirm user email' do
    before do
      @user = FactoryGirl.create(:user_email)
      visit aviso_path(@user.id)
    end
    it { should have_css('div.alert-success', 
                         :text => /la suscripción(.*)esta confirmada/i) }
  end

end
