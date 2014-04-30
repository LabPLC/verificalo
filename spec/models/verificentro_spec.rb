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

  it { should be_valid }
end
