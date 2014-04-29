require 'spec_helper'

describe Verificentro do
  before do
    delegacion = Delegacion.create(url: 'example-borough', 
                                   name: 'Example Borough')
    @verificentro = Verificentro.new(number: 123,
                                     name: 'Example Inc',
                                     address: 'Fake street 123',
                                     delegacion_id: delegacion.id,
                                     phone: '1234567890',
                                     lat: 19.43, lon: -99.14)
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
