require 'spec_helper'

describe AnswersController do
  before :all do
    FactoryGirl.create(:delegacion_verificentros, 
                       verificentros_count: 3)
    FactoryGirl.create(:delegacion_verificentros, 
                       verificentros_count: 6)
    FactoryGirl.create(:delegacion_verificentros, 
                       verificentros_count: 9)
  end

  describe 'GET home' do
    it 'should render home' do
      get :home
      response.should be_success
      should render_template('home')
    end
  end

  describe 'GET verificentros' do
    before do
      @verificentros_count = Verificentro.all.count
      @delegaciones_count = Delegacion.all.count
    end
    it 'should return verificentros count and delegaciones' do
      get :verificentros
      response.should be_success
      should render_template('verificentros')
      assigns(:verificentros_count).should eq(@verificentros_count)
      assigns(:delegaciones).count.should eq(@delegaciones_count)
    end
  end

  describe 'GET verificentros_query' do
    it 'should render form' do
      get :verificentros_query
      response.should be_success
      should render_template('verificentros_query')
    end
  end

  describe 'POST verificentros_query' do
    describe 'without params' do
      it 'should render form without response' do
        post :verificentros_query
        response.should be_success
        should render_template('verificentros_query')
        assigns(:query_value).should be_nil
        assigns(:verificentros).should be_nil        
      end
    end

    # TODO
    # describe 'with query' do
    # end
  end

  describe 'GET verificentros_delegacion' do
    describe 'with invalid delegacion' do
      it 'should redirect to verificentros' do
        get :verificentros_delegacion, { delegacion: 'invalid' }
        response.should redirect_to({ action: 'verificentros' })
      end      
    end

    describe 'with valid delegacion' do
      before do 
        @delegacion = Delegacion.order('RANDOM()').first
        @verificentros_count = @delegacion.verificentros.count
      end
      it 'should return verificentros' do
        get :verificentros_delegacion, { delegacion: @delegacion.url }
        response.should be_success
        should render_template('verificentros_delegacion')
        assigns(:delegacion).should_not be_nil
        assigns(:verificentros).count.should eq(@verificentros_count)
      end
    end

  end
end
