require 'spec_helper'

describe Phone do
  before { @phone = FactoryGirl.build(:phone) }

  subject { @phone }
  
  it { should belong_to(:user) }

  it { should respond_to(:user_id) }  
  it { should respond_to(:number) }
  it { should respond_to(:cellphone) }
  it { should respond_to(:morning) }
  it { should respond_to(:afternoon) }
  it { should respond_to(:night) }
  
  it { should be_valid }
  
  describe 'without number' do
    before { @phone.number = nil }
    it { should_not be_valid }
  end
  
  describe 'with invalid number' do
    before { @phone.number = '123' }
    it { should_not be_valid }
  end

  describe 'without cellphone' do
    before { @phone.cellphone = nil }
    it { should_not be_valid }
  end

  describe 'without schedule' do
    before do 
      @phone.morning = false
      @phone.afternoon = false
      @phone.night = false
    end
    it { should_not be_valid }
  end
end
