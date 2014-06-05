# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'answers views' do
  before :all  do
    FactoryGirl.create(:category_answers, answers_count: 9)
    FactoryGirl.create(:category_answers, answers_count: 6)
    FactoryGirl.create(:category_answers, answers_count: 3)
    FactoryGirl.create(:delegacion_verificentros,
                       verificentros_count: 9)
    FactoryGirl.create(:delegacion_verificentros,
                       verificentros_count: 6)
    FactoryGirl.create(:delegacion_verificentros,
                       verificentros_count: 3)
  end
  
  subject { page }
  
  describe 'home' do
    before do
      @categories_count = Category.count
      @answers_count = Category.all.collect{ |c|
        c.top_answers.count
      }.sum
      visit respuestas_path 
    end
    
    # navbar
    it { should have_link('Información', href: root_path) }
    it { should have_link('Avisos', href: avisos_path) }
    it { should have_link('Respuestas', href: respuestas_path) }
    it { should have_link('Mi suscripción', href: '#') }
    it { should have_link('Acerca', href: acerca_path) }
    
    # search
    it { should have_field('answers-search') }
    it { should have_button('Buscar') }      

    # content
    it { should have_css('h3.category', count: @categories_count) }
    it { should have_css('a.answer', count: @answers_count) }
    
    describe 'category' do
      before do
        @category = Category.first
        @answers_count = @category.answers.count
        click_link(@category.name)
      end
      it { should have_css('h1.category', text: @category.name) }
      it { should have_css('a.answer', count: @answers_count) }  
      
      describe 'answer' do
        before do
          @answer = @category.answers.first
          click_on(@answer.title)
        end
        it { should have_css('h1.question', text: @answer.title) }
        it { should have_css('div.answer', text: @answer.body) }
      end
    end

  end

  describe 'verificentros answer' do
    before do
      @delegaciones_count = Delegacion.count
      visit respuestas_verificacion_verificentros_path 
    end
    it { should have_field('query') }
    it { should have_button('Buscar') }
    it { should have_css('#list-delegaciones p',
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
