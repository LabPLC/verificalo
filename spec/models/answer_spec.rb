require 'spec_helper'

describe Answer do
  before do
    @answer = FactoryGirl.build(:answer)
  end

  subject { @answer }

  it { should belong_to(:category) }
  it { should belong_to(:contact) }
  it { should belong_to(:related_1) }
  it { should belong_to(:related_2) }
  it { should belong_to(:related_3) }
  it { should belong_to(:related_4) }
  it { should belong_to(:related_5) }

  it { should respond_to(:url) }
  it { should respond_to(:title) }
  it { should respond_to(:body) }
  it { should respond_to(:views) }
  it { should respond_to(:positive) }
  it { should respond_to(:negative) }

  it { should be_valid }
end
