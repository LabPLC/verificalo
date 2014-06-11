require 'spec_helper'

describe Category do
  before do
    @category = FactoryGirl.build(:category)
  end

  subject { @category }

  it { should have_many(:answers) }

  it { should respond_to(:url) }
  it { should respond_to(:name) }
  it { should respond_to(:priority) }

  it { should be_valid }

  describe 'without url' do
    before { @category.url = nil }
    it { should_not be_valid }
  end  

  describe 'without name' do
    before { @category.name = nil }
    it { should_not be_valid }
  end  

  describe 'without priority' do
    before { @category.priority = nil }
    it { should be_valid }
  end

  describe 'with invalid priority' do
    before { @category.priority = 'abc' }
    it { should_not be_valid }
  end

  describe 'with negative priority' do
    before { @category.priority = -1 }
    it { should_not be_valid }
  end
end
