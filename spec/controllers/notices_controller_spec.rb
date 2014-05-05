require 'spec_helper'

describe NoticesController do
  describe "GET home" do
    subject { get :home }
    it "should return without errors" do
      response.should be_success
      should render_template('home')
      assigns(:error).should be_nil
    end
  end
  
  describe "GET email" do
    subject { get :email }
    it "should return email form" do
      response.should be_success
      should render_template('email')
    end
  end

  describe "GET phone" do
    subject { get :phone }
    it "should return phone form" do
      response.should be_success
      should render_template('phone')
    end
  end

  describe "POST home" do
    describe "without params" do
      subject { post :home }
      it "should return without errors" do
        response.should be_success
        should render_template('home')
        assigns(:error).should be_nil        
      end
    end
    
    describe "via email" do
      describe "with invalid params" do
        subject do
          user = { via: 'EMAIL', plate: '', destination: '' }
          post :home, user: user
        end
        it "should return INVALID_PLATE and INVALID_EMAIL errors" do
          response.should be_success
          should render_template('home')
          expect(assigns(:errors)).to eq(INVALID_PLATE: true,
                                         INVALID_EMAIL: true)
        end
      end

      describe "with invalid plate" do
        subject do 
          user = { via: 'EMAIL', plate: '', 
            destination: FactoryGirl.generate(:email) }
          post :home, user: user
        end
        it "should return INVALID_PLATE error" do
          response.should be_success
          should render_template('home')
          expect(assigns(:errors)).to eq(INVALID_PLATE: true)
        end
      end

      describe "with invalid email" do
        subject do 
          user = { via: 'EMAIL', destination: '', 
            plate: FactoryGirl.generate(:plate) }
          post :home, user: user
        end
        it "should return INVALID_EMAIL error" do
          response.should be_success
          should render_template('home')
          expect(assigns(:errors)).to eq(INVALID_EMAIL: true)
        end
      end

      describe "without settings" do
        subject do 
          user = { via: 'EMAIL', 
            destination: FactoryGirl.generate(:email), 
            plate: FactoryGirl.generate(:plate) }
          post :home, user: user
        end
        it "should return INVALID_SETTINGS_COUNT error" do
          response.should be_success
          should render_template('home')
          expect(assigns(:errors)).to eq(INVALID_SETTINGS_COUNT: true)
        end
      end      

      describe "with invalid settings" do
        subject do 
          user = { via: 'EMAIL', 
            destination: FactoryGirl.generate(:email), 
            plate: FactoryGirl.generate(:plate) }
          settings = { INVALID: true }
          post :home, user: user, settings: settings
        end
        it "should show error" do
          response.should be_success
          should render_template('error')
        end
      end

      describe "with email, plate and settings" do
        subject do
          user = { via: 'EMAIL', 
            destination: FactoryGirl.generate(:email), 
            plate: FactoryGirl.generate(:plate) }
          settings = {
            VERIFICACION: true,
            ADEUDOS: true,
            NO_CIRCULA_WEEKEND: true }
          post :home, user: user, settings: settings
          @user = User.where(user)
        end
        it "should return without errors" do
          response.should be_success
          should render_template('results')
          expect(assigns(:errors)).to be_empty
          expect(@user).to_not be_nil
        end
      end
    end
  end

  describe "GET confirm" do
    describe "invalid user" do
      subject do
        get :confirm, user: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      end
      it "should return USER_NOT_FOUND error" do
        response.should be_success
        should render_template('confirm')
        expect(assigns(:error)).to eq('USER_NOT_FOUND')
      end
    end

    describe "valid user" do
      before { @user = FactoryGirl.create(:user_email) }
      subject do
        get :confirm, user: @user.id
        @user.reload
      end
      it "should return without errors" do
        response.should be_success
        should render_template('confirm')
        expect(assigns(:error)).to be_nil
        expect(@user.confirmed_at).to_not be_nil
      end
    end
  end

end
