require 'spec_helper'

shared_examples_for Setting do
  it { should belong_to(:user) }

  it { should respond_to(:user_id) }
  it { should respond_to(:setting) }
  it { should respond_to(:active) }

  it { should be_valid }

  describe 'without user' do
    before { @setting.user = nil }
    it { should_not be_valid }
  end
end

describe Setting do
  subject { @setting }
  
  describe 'verificacion' do
    before { @setting = FactoryGirl.build(:setting_verificacion) }
    it_behaves_like Setting
  end
  
  describe 'adeudos' do
    before { @setting = FactoryGirl.build(:setting_adeudos) }
    it_behaves_like Setting
  end

  describe 'hoy no circula weekday' do
    before { @setting = FactoryGirl.build(:setting_no_circula_weekday) }
    it_behaves_like Setting
  end

  describe 'hoy no circula weekend' do
    before { @setting = FactoryGirl.build(:setting_no_circula_weekend) }
    it_behaves_like Setting
  end
  
  describe 'invalid' do
    before do
      user = FactoryGirl.create(:user_email)
      @setting = Setting.new(user_id: user.id)
      @setting.setting = 'INVALID'
    end
    it { should_not be_valid }    
  end
end
