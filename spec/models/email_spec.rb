require 'spec_helper'

describe Email do
  before { @email = FactoryGirl.build(:email) }

  subject { @email }
  
  it { should belong_to(:user) }

  it { should respond_to(:user_id) }  
  it { should respond_to(:address) }
  
  it { should be_valid }
  
  describe 'without address' do
    before { @email.address = nil }
    it { should_not be_valid }
  end
  
  describe 'with invalid address' do
    before { @email.address = 'invalid@example' }
    it { should_not be_valid }
  end
end
