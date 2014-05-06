require 'spec_helper'

describe InfoController do
  describe 'GET home' do
    it 'should return without errors' do
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
      it 'should return MISSING_PLATE error' do
        post :home, plate: ''
        response.should be_success
        expect(assigns(:error)).to eq('MISSING_PLATE')
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

    # TODO    
    # describe 'a valid plate' do
    #   it 'should redirect to plate info' do
    #     # post :home, plate: '123abc'
    #   end
    # end

  end
end
