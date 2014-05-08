require 'spec_helper'

describe NoticesController do
  describe 'GET home' do
    it 'should return without errors' do
      get :home
      response.should be_success
      should render_template('home')
      assigns(:error).should be_nil
    end
  end
  
  describe 'GET email' do
    it 'should return email form' do
      get :email
      response.should be_success
      should render_template('email')
    end
  end

  describe 'GET phone' do
    it 'should return phone form' do
      get :phone
      response.should be_success
      should render_template('phone')
    end
  end

  describe 'POST new' do
    describe 'without params' do
      it 'should show error' do
        post :new
        response.should be_success
        should render_template('error')
      end
    end
    
    describe 'via email' do
      describe 'with invalid params' do
        it 'should return INVALID_PLATE and INVALID_DESTINATION errors' do
          user = { via: 'EMAIL', plate: '', destination: '' }
          post :new, user: user
          response.should be_success
          should render_template('home')
          expect(assigns(:errors)).to eq(INVALID_PLATE: true,
                                         INVALID_DESTINATION: true)
        end
      end

      describe 'with invalid plate' do
        it 'should return INVALID_PLATE error' do
          user = { via: 'EMAIL', plate: '', 
            destination: FactoryGirl.generate(:email) }
          post :new, user: user
          response.should be_success
          should render_template('home')
          expect(assigns(:errors)).to eq(INVALID_PLATE: true)
        end
      end

      describe 'with invalid email' do
        it 'should return INVALID_DESTINATION error' do
          user = { via: 'EMAIL', destination: '', 
            plate: FactoryGirl.generate(:plate) }
          post :new, user: user
          response.should be_success
          should render_template('home')
          expect(assigns(:errors)).to eq(INVALID_DESTINATION: true)
        end
      end

      describe 'without settings' do
        it 'should return INVALID_SETTINGS_COUNT error' do
          user = { via: 'EMAIL', 
            destination: FactoryGirl.generate(:email), 
            plate: FactoryGirl.generate(:plate) }
          post :new, user: user
          response.should be_success
          should render_template('home')
          expect(assigns(:errors)).to eq(INVALID_SETTINGS_COUNT: true)
        end
      end      

      describe 'with invalid settings' do
        it 'should show error' do
          user = { via: 'EMAIL', 
            destination: FactoryGirl.generate(:email), 
            plate: FactoryGirl.generate(:plate) }
          settings = { INVALID: true }
          post :new, user: user, settings: settings
          response.should be_success
          should render_template('error')
        end
      end

      describe 'with email, plate and settings' do
        it 'should create user' do
          user = { via: 'EMAIL', 
            destination: FactoryGirl.generate(:email), 
            plate: FactoryGirl.generate(:plate) }
          settings = {
            VERIFICACION: true,
            ADEUDOS: true,
            NO_CIRCULA_WEEKEND: true }
          post :new, user: user, settings: settings
          response.should be_success
          should render_template('new')
          expect(assigns(:errors)).to be_empty
          expect(User.where(user)).to_not be_nil
        end
      end
    end

    describe 'via invalid' do
      it 'should render error' do
        user = { via: 'INVALID', 
          destination: FactoryGirl.generate(:email), 
          plate: FactoryGirl.generate(:plate) }
        settings = {
          VERIFICACION: true,
          ADEUDOS: true,
          NO_CIRCULA_WEEKEND: true }
        post :new, user: user, settings: settings
        response.should be_success
        should render_template('error')
        expect(assigns(:errors)).to be_empty
        expect(User.where(user)).to_not be_nil
      end
    end
  end

  describe 'GET confirm' do
    describe 'invalid user' do
      it 'should return USER_NOT_FOUND error' do
        get :confirm, user: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
        response.should be_success
        should render_template('confirm')
        expect(assigns(:error)).to eq('USER_NOT_FOUND')
      end
    end

    describe 'valid user' do
      before { @user = FactoryGirl.create(:user_email) }
      it 'should confirm user' do
        get :confirm, user: @user.id
        @user.reload
        response.should be_success
        should render_template('confirm')
        expect(assigns(:error)).to be_nil
        expect(@user.confirmed_at).to_not be_nil
      end
    end
  end

end
