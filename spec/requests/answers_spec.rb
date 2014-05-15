# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'questions' do
  before :all  do
    FactoryGirl.create(:delegacion_verificentros,
                       verificentros_count: 3)
    FactoryGirl.create(:delegacion_verificentros,
                       verificentros_count: 6)
    FactoryGirl.create(:delegacion_verificentros,
                       verificentros_count: 9)
  end
  
  subject { page }

  describe 'home' do
    before { visit respuestas_path }

    describe 'navbar' do
      it { should have_link('Información', href: root_path) }
      it { should have_link('Avisos', href: avisos_path) }
      it { should have_link('Respuestas', href: respuestas_path) }
    end

    it { should have_link('¿Donde debo llevar mi auto a verificar?',
                          href: respuestas_verificentros_path) }
  end

  describe 'verificentros answer' do
    before do
      @delegaciones_count = Delegacion.all.count
      visit respuestas_verificentros_path 
    end
    it { should have_field('query') }
    it { should have_button('Buscar') }
    it { should have_css('ul#list-delegaciones li a', 
                         count: @delegaciones_count) }

    # TODO
    # describe 'verificentros cercanos' do
    # end

    describe 'verificentros delegacion' do
      before do
        @delegacion = Delegacion.order('RANDOM()').first
        @verificentros_count = @delegacion.verificentros.count
        click_link(@delegacion.name)
      end
      it { should have_css('h2.answer', count: @verificentros_count) }
    end
  end
  
end
