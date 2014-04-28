# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Info' do
  subject { page }

  describe 'home' do
    before { visit info_path }

    describe 'default' do
      it { should have_content('Ingrese la placa de su auto y consulte el estado de su verificacion, hoy no circula, infracciones y tenencias.') }
      it { should have_field('plate') }
      it { should have_button('Continuar') }
    end

    describe 'post without plate' do
      before { find_button('Continuar').click }
      it { should have_content('La placa que ingreso no es valida: Debe contener números y letras.') }
      it { should have_field('plate') }
      it { should have_button('Continuar') }    
    end

    describe 'post with a long plate' do
      before { 
        fill_in('plate', with: 'abdefghijklmnopqrstuvwxyz')
        find_button('Continuar').click 
      }
      it { should have_content('La placa que ingreso no es valida: Debe contener máximo 14 números y letras.') }
      it { should have_field('plate') }
      it { should have_button('Continuar') }    
    end
  end

end
