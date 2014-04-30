require 'spec_helper'

describe Delegacion do
  before do
    @delegacion = FactoryGirl.build(:delegacion)
  end

  subject { @delegacion }

  it { should have_many(:verificentros) }

  it { should respond_to(:url) }
  it { should respond_to(:name) }

  it { should be_valid }
end
