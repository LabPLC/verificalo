require 'spec_helper'

describe AnswersController do
  before :all do
    FactoryGirl.create(:category_answers, 
                       answers_count: 3)
    FactoryGirl.create(:category_answers, 
                       answers_count: 6)
    FactoryGirl.create(:category_answers, 
                       answers_count: 9)
    FactoryGirl.create(:delegacion_verificentros, 
                       verificentros_count: 3)
    FactoryGirl.create(:delegacion_verificentros, 
                       verificentros_count: 6)
    FactoryGirl.create(:delegacion_verificentros, 
                       verificentros_count: 9)
  end

  describe 'GET home' do
    before do
      @categories_count = Category.count
    end
    it 'should render home with categories' do
      get :home
      response.should be_success
      should render_template('home')
      assigns(:categories).count.should eq(@categories_count)
    end
  end

  describe 'GET category' do
    describe 'with invalid url' do
      it 'should redirect to home' do
        get :category, { category_url: 'invalid' }
        response.should redirect_to({ action: 'home' })
      end      
    end

    describe 'with valid url' do
      before do 
        @category = Category.order('RANDOM()').first
        @answers_count = @category.answers.count
      end
      it 'should return answers' do
        get :category, { category_url: @category.url }
        response.should be_success
        should render_template('category')
        assigns(:category).should_not be_nil
        assigns(:answers).count.should eq(@answers_count)
      end
    end
  end

  describe 'GET answer' do
    before do 
      @category = Category.order('RANDOM()').first
    end
    describe 'with invalid url' do
      it 'should redirect to home' do
        get :answer, { category_url: @category.url, answer_url: 'invalid' }
        response.should redirect_to({ action: 'home' })
      end
    end
    
    describe 'with valid url' do
      before do 
        @answer = @category.answers.order('RANDOM()').first
      end
      it 'should return answer' do
        get :answer, { category_url: @category.url, answer_url: @answer.url }
        response.should be_success
        should render_template('answer')
        assigns(:answer).should_not be_nil
      end
    end
  end

  # TODO
  # describe 'GET search' do
  #   it 'should render form' do
  #     get :search
  #     response.should be_success
  #     should render_template('search')
  #   end
  # end
  # describe 'POST search' do
  #   describe 'without params' do
  #   end    
  #   describe 'with query' do
  #   end
  # end

  describe 'GET verificentros' do
    before do
      @verificentros_count = Verificentro.count
      @delegaciones_count = Delegacion.count
    end
    it 'should return verificentros count and delegaciones' do
      get :verificentros
      response.should be_success
      should render_template('verificentros')
      assigns(:verificentros_count).should eq(@verificentros_count)
      assigns(:delegaciones).count.should eq(@delegaciones_count)
    end
  end

  # TODO
  # describe 'GET verificentros_search' do
  #   it 'should render form' do
  #     get :verificentros_search
  #     response.should be_success
  #     should render_template('verificentros_search')
  #   end
  # end
  # describe 'POST verificentros_search' do
  #   describe 'without params' do
  #     it 'should render form without response' do
  #       post :verificentros_search
  #       response.should be_success
  #       should render_template('verificentros_search')
  #       assigns(:verificentros).should be_nil        
  #     end
  #   end    
  #   describe 'with query' do
  #   end
  # end

  describe 'GET verificentros_delegacion' do
    describe 'with invalid delegacion' do
      it 'should redirect to verificentros' do
        get :verificentros_delegacion, { delegacion_url: 'invalid' }
        response.should redirect_to({ action: 'verificentros' })
      end      
    end
    describe 'with valid delegacion' do
      before do 
        @delegacion = Delegacion.order('RANDOM()').first
        @verificentros_count = @delegacion.verificentros.count
      end
      it 'should return verificentros' do
        get :verificentros_delegacion, { delegacion_url: @delegacion.url }
        response.should be_success
        should render_template('verificentros_delegacion')
        assigns(:delegacion).should_not be_nil
        assigns(:verificentros).count.should eq(@verificentros_count)
      end
    end
  end
end
