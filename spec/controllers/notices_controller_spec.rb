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

    describe 'with invalid plate' do
      it 'should return INVALID_PLATE error' do
        user = FactoryGirl.attributes_for(:user)
        user[:plate] = ''
        email = FactoryGirl.attributes_for(:email)
        post :new, type: 'email', user: user, email: email
        response.should be_success
        should render_template('home')
        expect(assigns(:errors)).to eq(INVALID_USER_PLATE: true)
      end
    end

    describe 'without notices' do
      it 'should return MISSING_USER_NOTICES error' do
        user = FactoryGirl.attributes_for(:user)
        user[:adeudos] = false
        user[:verificacion] = false
        user[:no_circula_weekday] = false
        user[:no_circula_weekend] = false
        email = FactoryGirl.attributes_for(:email)
        post :new, type: 'email', user: user, email: email
        response.should be_success
        should render_template('home')
        expect(assigns(:errors)).to eq(MISSING_USER_NOTICES: true)
      end
    end
    
    describe 'via email' do
      describe 'with invalid address' do
        it 'should return INVALID_EMAIL_ADDRESS error' do
          user = FactoryGirl.attributes_for(:user)
          email = FactoryGirl.attributes_for(:email)
          email[:address] = ''
          post :new, type: 'email', user: user, email: email
          response.should be_success
          should render_template('home')
          expect(assigns(:errors)).to eq(INVALID_EMAIL_ADDRESS: true)
        end
      end
      
      describe 'with user and email' do
        it 'should create user' do
          user = FactoryGirl.attributes_for(:user)
          email = FactoryGirl.attributes_for(:email)
          post :new, type: 'email', user: user, email: email
          response.should be_success
          should render_template('new')
          expect(assigns(:errors)).to be_empty
          expect(User.where(user)).to_not be_empty
          expect(Email.where(email)).to_not be_empty
        end
      end
    end

    describe 'via phone' do
      describe 'with invalid number' do
        it 'should return INVALID_PHONE_NUMBER error' do
          user = FactoryGirl.attributes_for(:user)
          phone = FactoryGirl.attributes_for(:phone)
          phone[:number] = ''
          post :new, type: 'phone', user: user, phone: phone
          response.should be_success
          should render_template('home')
          expect(assigns(:errors)).to eq(INVALID_PHONE_NUMBER: true)
        end
      end

      describe 'without schedule' do
        it 'should return MISSING_PHONE_SCHEDULE error' do
          user = FactoryGirl.attributes_for(:user)
          phone = FactoryGirl.attributes_for(:phone)
          phone[:morning] = false
          phone[:afternoon] = false
          phone[:night] = false
          post :new, type: 'phone', user: user, phone: phone
          response.should be_success
          should render_template('home')
          expect(assigns(:errors)).to eq(MISSING_PHONE_SCHEDULE: true)
        end
      end

      describe 'with user and phone' do
        it 'should create user' do
          user = FactoryGirl.attributes_for(:user)
          phone = FactoryGirl.attributes_for(:phone)
          post :new, type: 'phone', user: user, phone: phone
          response.should be_success
          should render_template('new')
          expect(assigns(:errors)).to be_empty
          expect(User.where(user)).to_not be_empty
          expect(Phone.where(phone)).to_not be_empty
        end
      end
    end

    describe 'via invalid' do
      it 'should render error' do
        user = FactoryGirl.attributes_for(:user)
        email = FactoryGirl.attributes_for(:email)
        post :new, type: 'invalid', user: user, email: email
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
      before do
        @email = FactoryGirl.create(:email)
        @user = @email.user
      end
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
