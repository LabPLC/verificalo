require 'spec_helper'

describe StaticPagesController do
  describe 'GET home' do
    it 'should render home' do
      get :home
      response.should be_success
      should render_template('home')
    end
  end
end
