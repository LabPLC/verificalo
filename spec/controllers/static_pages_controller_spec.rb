require 'spec_helper'

describe StaticPagesController do
  describe "GET home" do
    subject { get :home }
    it { response.should be_success }
    it { should render_template('home') }
  end
end
