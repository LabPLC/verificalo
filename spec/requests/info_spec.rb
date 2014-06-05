# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'info views' do

  describe 'home' do
    before { visit root_path }
    
    subject { page }
        
    # navbar
    it { should_not have_link('Información', href: root_path) }
    it { should_not have_link('Avisos', href: avisos_path) }
    it { should_not have_link('Respuestas', href: respuestas_path) }
    it { should have_link('Acerca', href: acerca_path) }
    
    # jumbotron
    it { should have_css('div.jumbotron', :text => /ingrese la placa/i) }
    it { should have_field('plate') }
    it { should have_button('Consulta') }

    # grid
    it { should have_link('Suscribirse', href: avisos_path) }
    it { should have_link('Preguntar', href: respuestas_path) }

    # content
    it { should have_title('Verifícalo') }
    
    # TODO    
    # describe 'query plate' do
    #   before do
    #     fill_in('plate', with:  '123abc')
    #     click_button('Continuar') 
    #   end
    # end
  end
end
