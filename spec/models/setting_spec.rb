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
  before do
    user = User.create(plate: '123abc', via: 'EMAIL',
                       destination: 'example@example.com')
    @setting = Setting.new(user_id: user.id)
  end

  subject { @setting }
  
  describe 'verificacion' do
    before { @setting.setting = 'VERIFICACION' }
    it_behaves_like Setting
  end
  
  describe 'adeudos' do
    before { @setting.setting = 'ADEUDOS' }
    it_behaves_like Setting
  end

  describe 'hoy no circula weekday' do
    before { @setting.setting = 'NO_CIRCULA_WEEKDAY' }
    it_behaves_like Setting
  end

  describe 'hoy no circula weekend' do
    before { @setting.setting = 'NO_CIRCULA_WEEKEND' }
    it_behaves_like Setting
  end

  describe 'invalid' do
    before { @setting.setting = 'OTHER' }
    it { should_not be_valid }    
  end
end
