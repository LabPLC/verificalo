# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'visit homepage' do
  before { visit root_path }

  subject { page }

  it { should have_title('Verifícalo') }
  
  describe 'navbar' do
    it { should have_link('Información', href: root_path) }
    it { should have_link('Avisos', href: avisos_path) }
    it { should have_link('Respuestas', href: respuestas_path) }
  end
  
  describe 'jumbotron' do
    it { should have_css('div.jumbotron', 
                         :text => /conozca sus obligaciones/i) }
    it { should have_field('plate') }
    it { should have_button('Consulta') }
  end
  
  describe 'grid' do
    it { should have_link('Suscribirse', href: avisos_path) }
    it { should have_link('Preguntar', href: respuestas_path) }
  end
  
  # TODO    
  # describe 'query plate' do
  #   before do
  #     fill_in('plate', with:  '123abc')
  #     click_button('Continuar') 
  #   end
  # end

end
