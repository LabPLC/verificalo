require 'spec_helper'

describe Verificentro do
  before do
    @verificentro = FactoryGirl.build(:verificentro)
  end
  
  subject { @verificentro }

  it { should belong_to(:delegacion) }

  it { should respond_to(:number) }
  it { should respond_to(:name) }
  it { should respond_to(:address) }
  it { should respond_to(:delegacion_id) }
  it { should respond_to(:phone) }
  it { should respond_to(:lat) }
  it { should respond_to(:lon) }
  it { should respond_to(:suspended) }

  it { should be_valid }

  describe 'without number' do
    before { @verificentro.number = nil }
    it { should_not be_valid }
  end

  describe 'without name' do
    before { @verificentro.name = nil }
    it { should_not be_valid }
  end

  describe 'without address' do
    before { @verificentro.address = nil }
    it { should_not be_valid }
  end

  describe 'without delegacion' do
    before { @verificentro.delegacion = nil }
    it { should_not be_valid }
  end
  
  describe 'without lat' do
    before { @verificentro.lat = nil }
    it { should_not be_valid }
  end

  describe 'without lon' do
    before { @verificentro.lon = nil }
    it { should_not be_valid }
  end

  describe 'with invalid lat' do
    before { @verificentro.lat = 'abc' }
    it { should_not be_valid }
  end
  
  describe 'with invalid lon' do
    before { @verificentro.lon = 'abc' }
    it { should_not be_valid }
  end
end
