require 'spec_helper'

shared_examples_for User do
  it { should have_many(:settings) }

  it { should respond_to(:plate) }
  it { should respond_to(:via) }
  it { should respond_to(:destination) }
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
end

describe User do
  describe 'via email' do
    before do
      @user = User.new(plate: '123abc', via: 'EMAIL', 
                       destination: 'example@example.com')
    end
    
    subject { @user }
    it_behaves_like User  
    
    describe 'without email' do
      before { @user.destination = '' }
      it { should_not be_valid }  
    end
    
    describe 'with invalid email' do
      before { @user.destination = 'example@example' }
      it { should_not be_valid }      
    end    
  end

  describe 'via phone' do
    before do 
      @user = User.new(plate: '123abc', via: 'PHONE', 
                       destination: '1234567890')
    end

    subject { @user }
    it_behaves_like User

    describe 'without phone' do
      before { @user.destination = '' }
      it { should_not be_valid }  
    end
    
    describe 'with invalid phone' do
      before { @user.destination = '12345678901234567890' }
      it { should_not be_valid }
    end    
  end

  describe 'via invalid' do
    before do
      @user = User.new(plate: '123abc', via: 'OTHER', 
                       destination: 'example@example.com')
    end

    subject { @user }
    it { should_not be_valid }
  end
end
