require 'spec_helper'

describe InfoController do
  describe 'GET home' do
    it 'should render home' do
      get :home
      response.should be_success
      assigns(:error).should be_nil
      should render_template('home')
    end
  end

  describe 'POST home' do
    describe 'without params' do
      it 'should return without errors' do
        post :home
        response.should be_success
        assigns(:error).should be_nil
        should render_template('home')
      end
    end

    describe 'an empty plate' do
      it 'should return INVALID_PLATE error' do
        post :home, plate: ''
        response.should be_success
        expect(assigns(:error)).to eq('INVALID_PLATE')
        should render_template('home')
      end
    end

    describe 'an invalid plate' do
      it 'should return INVALID_PLATE error' do
        post :home, plate: 'abcdefghijklmnopqrstuvwxyz'
        response.should be_success
        expect(assigns(:error)).to eq('INVALID_PLATE')
        should render_template('home')
      end
    end

    describe 'try again later' do
      before { stub_datalab('intente_mas_tarde') }
      it 'should return API_VERIFICACIONES_ERROR error' do
        post :home, plate: '123ABC'
        response.should be_success
        expect(assigns(:error)).to eq('API_VERIFICACIONES_ERROR')
        should render_template('home')
      end
    end

    describe 'a valid plate' do
      before { stub_datalab('verificacion_ok_cero') }
      it 'should redirect to results' do
        post :home, plate: '123ABC'
        response.should redirect_to({ action: 'results', plate: '123ABC' })
      end
    end
  end
  
  describe 'GET results' do
    before { stub_datalab('verificacion_ok_cero') }
    it 'should show results and set plate in session' do
      get :results, plate: '123ABC'
      response.should be_success
      should render_template('results')
      expect(session[:plate]).to eq('123ABC')
      expect(session[:vin]).to be_nil
      expect(session[:registration_date]).to be_nil
    end
    describe 'multiple vins' do
      before { stub_datalab('verificacion_multiple_vins') }
      it 'should ask vin and set plate in session' do
        get :results, plate: '123ABC'
        response.should be_success
        should render_template('vin')
        expect(session[:plate]).to eq('123ABC')
        expect(session[:vin]).to be_nil
        expect(session[:registration_date]).to be_nil
      end
    end
    describe 'verificaciones empty' do
      before { stub_datalab('verificacion_none') }
      it 'should ask registration date and set plate in session' do
        get :results, plate: '123ABC'
        response.should be_success
        should render_template('registration')
        expect(session[:plate]).to eq('123ABC')
        expect(session[:vin]).to be_nil
        expect(session[:registration_date]).to be_nil
      end
    end
  end

  describe 'POST results' do

    describe 'multiple vins' do
      before { stub_datalab('verificacion_multiple_vins') }
      describe 'without vin' do
        it 'should ask vin and set plate in session' do
          post :results, plate: '123ABC'
          response.should be_success
          should render_template('vin')
          expect(session[:plate]).to eq('123ABC')
          expect(session[:vin]).to be_nil
          expect(session[:registration_date]).to be_nil
        end
      end
      describe 'with vin' do
        it 'should render results and set plate/vin in session' do
          post :results, plate: '123ABC', vin: '1234567890ABCDEFG'
          response.should be_success
          should render_template('results')
          expect(session[:plate]).to eq('123ABC')
          expect(session[:vin]).to eq('1234567890ABCDEFG')
          expect(session[:registration_date]).to be_nil
        end
      end
      describe 'with vin and verificaciones rechazo' do
        it 'should ask registration date and set plate/vin in session' do
          post :results, plate: '123ABC', vin: '1234567890TUVWXYZ'
          response.should be_success
          should render_template('registration')
          expect(session[:plate]).to eq('123ABC')
          expect(session[:vin]).to eq('1234567890TUVWXYZ')
          expect(session[:registration_date]).to be_nil
        end
        describe 'with vin/registration date and verificaciones rechazo' do
          it 'should ask registration date and set plate/vin/registration_date in session' do
            registration = Date.today.months_ago(2)
            params = { plate: '123ABC', vin: '1234567890TUVWXYZ', registration:
              { day: registration.day, 
                month: registration.month, 
                year: registration.year } }
            post :results, params
            response.should be_success
            should render_template('results')
            expect(session[:plate]).to eq('123ABC')
            expect(session[:vin]).to eq('1234567890TUVWXYZ')
            expect(session[:registration_date]).to eq(registration.to_s(:db))
          end
        end
      end
    end

    describe 'verificaciones empty' do
      before { stub_datalab('verificacion_none') }
      describe 'without registration date' do
        it 'should ask registration date and set plate in session' do
          post :results, plate: '123ABC'
          response.should be_success
          should render_template('registration')
          expect(session[:plate]).to eq('123ABC')
          expect(session[:vin]).to be_nil
          expect(session[:registration_date]).to be_nil
        end
      end
      describe 'with invalid registration date' do
        it 'should ask registration date and set plate in session' do
          registration = Date.today.months_since(1)
          params_registration = { day: registration.day, 
            month: registration.month, 
            year: registration.year }
          post :results, plate: '123ABC', registration: params_registration
          response.should be_success
          should render_template('registration')
          expect(session[:plate]).to eq('123ABC')
          expect(session[:vin]).to be_nil
          expect(session[:registration_date]).to be_nil
        end
      end
      describe 'with registration date' do
        it 'should render results and set plate/registration_date in session' do
          registration = Date.today.months_ago(2)
          params_registration = { day: registration.day, 
            month: registration.month, 
            year: registration.year }
          post :results, plate: '123ABC', registration: params_registration
          response.should be_success
          should render_template('results')
          expect(session[:plate]).to eq('123ABC')
          expect(session[:vin]).to be_nil
          expect(session[:registration_date]).to eq(registration.to_s(:db))
        end
      end
    end
  end

  describe 'GET verificaciones' do
    before { stub_datalab('verificacion_ok_cero') }
    it 'should show results' do
      get :verificaciones, plate: '123ABC'
      response.should be_success
      should render_template('verificaciones')
    end
    describe 'multiple vins and without vin in session' do
      before { stub_datalab('verificacion_multiple_vins') }
      it 'should redirect to results' do
        post :verificaciones, plate: '123ABC'
        response.should redirect_to({ action: 'results', plate: '123ABC' })
        expect(session[:vin]).to be_nil
      end
    end
    describe 'verificaciones empty and without registration date in session' do
      before { stub_datalab('verificacion_none') }
      it 'should redirect to results' do
        post :verificaciones, plate: '123ABC'
        response.should redirect_to({ action: 'results', plate: '123ABC' })
        expect(session[:registration_date]).to be_nil
      end
    end
  end

  describe 'GET infracciones' do
    before { stub_datalab('verificacion_ok_cero') }
    it 'should show results' do
      get :verificaciones, plate: '123ABC'
      response.should be_success
      should render_template('verificaciones')
    end
    describe 'multiple vins and without vin in session' do
      before { stub_datalab('verificacion_multiple_vins') }
      it 'should redirect to results' do
        post :infracciones, plate: '123ABC'
        response.should redirect_to({ action: 'results', plate: '123ABC' })
        expect(session[:vin]).to be_nil
      end
    end
    describe 'verificaciones empty and without registration date in session' do
      before { stub_datalab('verificacion_none') }
      it 'should redirect to results' do
        post :infracciones, plate: '123ABC'
        response.should redirect_to({ action: 'results', plate: '123ABC' })
        expect(session[:registration_date]).to be_nil
      end
    end
  end

  describe 'GET reset' do
    before do
      stub_datalab('verificacion_multiple_vins')
      @registration = Date.today.months_ago(2)
      params = { plate: '123ABC', vin: '1234567890TUVWXYZ', registration:
        { day: @registration.day, 
          month: @registration.month, 
          year: @registration.year } }
      post :results, params
    end
    describe 'vin' do
      it 'should redirect to results and delete vin from session' do
        get :reset, plate: '123ABC', item: 'vin'
        response.should redirect_to({ action: 'results', plate: '123ABC' })
        expect(session[:plate]).to eq('123ABC')
        expect(session[:vin]).to be_nil
        expect(session[:registration_date]).to eq(@registration.to_s(:db))        
      end
    end
    describe 'alta' do
      it 'should redirect to results and delete registration_date from session' do
        get :reset, plate: '123ABC', item: 'alta'
        response.should redirect_to({ action: 'results', plate: '123ABC' })
        expect(session[:plate]).to eq('123ABC')
        expect(session[:vin]).to eq('1234567890TUVWXYZ')
        expect(session[:registration_date]).to be_nil
      end
    end
  end
end
