require 'spec_helper'

describe Contact do
  before do
    @contact = FactoryGirl.build(:contact)
  end

  subject { @contact }

  it { should have_many(:answers) }
  
  it { should respond_to(:name) }
  it { should respond_to(:phone) }
  it { should respond_to(:phone_schedule) }
  it { should respond_to(:email) }
  it { should respond_to(:address) }
  it { should respond_to(:address_schedule) }
  it { should respond_to(:lat) }
  it { should respond_to(:lon) }

  it { should be_valid }
end
