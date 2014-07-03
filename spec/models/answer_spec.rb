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
  it { should respond_to(:source) }
  it { should respond_to(:views) }
  it { should respond_to(:positive) }
  it { should respond_to(:negative) }

  it { should be_valid }

  describe 'without url' do
    before { @answer.url = nil }
    it { should_not be_valid }
  end

  describe 'without title' do
    before { @answer.title = nil }
    it { should_not be_valid }
  end

  describe 'without body' do
    before { @answer.body = nil }
    it { should_not be_valid }
  end

  describe 'without category' do
    before { @answer.category = nil }
    it { should_not be_valid }
  end

  describe 'without views' do
    before { @answer.views = nil }
    it { should_not be_valid }    
  end

  describe 'with invalid views' do
    before { @answer.views = -1 }
    it { should_not be_valid }    
  end

  describe 'without positive' do
    before { @answer.positive = nil }
    it { should_not be_valid }    
  end

  describe 'with invalid positive' do
    before { @answer.positive = -1 }
    it { should_not be_valid }    
  end

  describe 'without negative' do
    before { @answer.negative = nil }
    it { should_not be_valid }    
  end

  describe 'with invalid negative' do
    before { @answer.negative = -1 }
    it { should_not be_valid }    
  end
end
