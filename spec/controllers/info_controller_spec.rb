require 'spec_helper'

describe InfoController do
  describe "GET home" do
    subject { get :home }
    it "should return without errors" do
      response.should be_success
      should render_template('home')
      assigns(:error).should be_nil
    end
  end

  describe "POST home" do
    describe "an empty plate" do
      subject { post :home, plate: '' }
      it "should return MISSING_PLATE error" do
        response.should be_success
        should render_template('home')
        expect(assigns(:error)).to eq('MISSING_PLATE')
      end
    end

    describe "an invalid plate" do
      subject { post :home, plate: 'abcdefghijklmnopqrstuvwxyz' }
      it "should return INVALID_PLATE error" do
        response.should be_success
        should render_template('home')
        expect(assigns(:error)).to eq('INVALID_PLATE')
      end
    end
    
    describe "a valid plate" do
      subject { post :home, { plate: '123abc' } }
      it "should redirect to plate info" do
        # TODO
      end
    end

  end
end
