require 'spec_helper'

describe Category do
  before do
    @category = FactoryGirl.build(:category)
  end

  subject { @category }

  #it { should have_many(:verificentros) }

  it { should respond_to(:url) }
  it { should respond_to(:name) }
  it { should respond_to(:order) }

  it { should be_valid }
end
