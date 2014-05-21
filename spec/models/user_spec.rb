require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }
  
  subject { @user }
  
  it { should have_one(:email) }
  it { should have_one(:phone) }
  
  it { should respond_to(:plate) }
  it { should respond_to(:adeudos) }
  it { should respond_to(:verificacion) }
  it { should respond_to(:no_circula_weekday) }
  it { should respond_to(:no_circula_weekend) }
  it { should respond_to(:confirmed_at) }
  it { should respond_to(:declined_at) }
  
  it { should be_valid }
  
  describe 'without plate' do
    before { @user.plate = '' }
    it { should_not be_valid }
  end
  
  describe 'with invalid plate' do
    before { @user.plate = 'abcdefghijklmnopqrstuvwxyz' }
    it { should_not be_valid }
  end  
  
  describe 'without notices' do
    before do 
      @user.adeudos = false
      @user.verificacion = false
      @user.no_circula_weekday = false
      @user.no_circula_weekend = false
    end
    it { should_not be_valid }
  end
end
