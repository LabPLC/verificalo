require 'spec_helper'
require 'vehicle_cdmx'

shared_examples 'vehicle cdmx ok' do
  it 'error should return false' do
    expect(subject.error).to eq(false)
  end
end

shared_examples 'verificacion ok' do
  it 'verificacion_ok? should return true' do
    expect(subject.verificacion_ok?).to eq(true)
    expect(subject.verificacion_period?).to eq(false)
    expect(subject.verificacion_expired?).to eq(false)
    expect(subject.verificacion_first_ok?).to eq(false)
    expect(subject.verificacion_first_expired?).to eq(false)
  end
end

shared_examples 'verificacion period' do
  it 'verificacion_period? should return true' do
    expect(subject.verificacion_ok?).to eq(false)
    expect(subject.verificacion_period?).to eq(true)
    expect(subject.verificacion_expired?).to eq(false)
    expect(subject.verificacion_first_ok?).to eq(false)
    expect(subject.verificacion_first_expired?).to eq(false)
  end
end

shared_examples 'verificacion expired' do
  it 'verificacion_expired? should return true' do
    expect(subject.verificacion_ok?).to eq(false)
    expect(subject.verificacion_period?).to eq(false)
    expect(subject.verificacion_expired?).to eq(true)
    expect(subject.verificacion_first_ok?).to eq(false)
    expect(subject.verificacion_first_expired?).to eq(false)
  end
end

shared_examples 'verificacion first ok' do
  it 'verificacion_first_ok? should return true' do
    expect(subject.verificacion_ok?).to eq(false)
    expect(subject.verificacion_period?).to eq(false)
    expect(subject.verificacion_expired?).to eq(false)
    expect(subject.verificacion_first_ok?).to eq(true)
    expect(subject.verificacion_first_expired?).to eq(false)
  end
end

shared_examples 'verificacion first expired' do
  it 'verificacion_first_expired? should return true' do
    expect(subject.verificacion_ok?).to eq(false)
    expect(subject.verificacion_period?).to eq(false)
    expect(subject.verificacion_expired?).to eq(false)
    expect(subject.verificacion_first_ok?).to eq(false)
    expect(subject.verificacion_first_expired?).to eq(true)
  end
end

shared_examples 'no circula cero' do
  it 'no_circula_cero? should return true' do
    expect(subject.no_circula_cero?).to eq(true)
    expect(subject.no_circula_uno?).to eq(false)
    expect(subject.no_circula_dos?).to eq(false)
    expect(subject.no_circula_never?).to eq(false)
    expect(subject.no_circula_expired?).to eq(false)
  end
end

shared_examples 'no circula uno' do
  it 'no_circula_uno? should return true' do
    expect(subject.no_circula_cero?).to eq(false)
    expect(subject.no_circula_uno?).to eq(true)
    expect(subject.no_circula_dos?).to eq(false)
    expect(subject.no_circula_never?).to eq(false)
    expect(subject.no_circula_expired?).to eq(false)
  end
end

shared_examples 'no circula dos' do
  it 'no_circula_dos? should return true' do
    expect(subject.no_circula_cero?).to eq(false)
    expect(subject.no_circula_uno?).to eq(false)
    expect(subject.no_circula_dos?).to eq(true)
    expect(subject.no_circula_never?).to eq(false)
    expect(subject.no_circula_expired?).to eq(false)
  end
end

shared_examples 'no circula never' do
  it 'no_circula_never? should return true' do
    expect(subject.no_circula_cero?).to eq(false)
    expect(subject.no_circula_uno?).to eq(false)
    expect(subject.no_circula_dos?).to eq(false)
    expect(subject.no_circula_never?).to eq(true)
    expect(subject.no_circula_expired?).to eq(false)
  end
end

shared_examples 'no circula expired' do
  it 'no_circula_expired? should return true' do
    expect(subject.no_circula_cero?).to eq(false)
    expect(subject.no_circula_uno?).to eq(false)
    expect(subject.no_circula_dos?).to eq(false)
    expect(subject.no_circula_never?).to eq(false)
    expect(subject.no_circula_expired?).to eq(true)
  end
end

shared_examples 'no info' do
  it 'none should return true' do  
    expect(subject.verificacion_ok?).to eq(false)
    expect(subject.verificacion_period?).to eq(false)
    expect(subject.verificacion_expired?).to eq(false)
    expect(subject.verificacion_first_ok?).to eq(false)
    expect(subject.verificacion_first_expired?).to eq(false)
    expect(subject.no_circula_cero?).to eq(false)
    expect(subject.no_circula_uno?).to eq(false)
    expect(subject.no_circula_dos?).to eq(false)
    expect(subject.no_circula_never?).to eq(false)
    expect(subject.no_circula_expired?).to eq(false)
  end
end

shared_examples 'no adeudos' do
  it 'adeudos? should return false' do
    expect(subject.adeudos?).to eq(false)
  end
end

describe VehicleCDMX do

  subject { @vehicle }

  context 'json error' do
    before do
      stub_datalab('json_error')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it 'error should return API_JSON_ERROR' do
      expect(@vehicle.error).to eq('API_JSON_ERROR')
    end
  end
  
  context 'intente mas tarde' do
    before do
      stub_datalab('intente_mas_tarde')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it 'error should return API_TRY_LATER' do
      expect(@vehicle.error).to eq('API_TRY_LATER')
    end
  end
  
  context 'verificacion ok holograma cero' do
    before do
      stub_datalab('verificacion_ok_cero')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it_should_behave_like 'vehicle cdmx ok'
    it_should_behave_like 'verificacion ok'
    it_should_behave_like 'no circula cero'    
    it_should_behave_like 'no adeudos'
  end

  context 'verificacion ok holograma uno' do
    before do
      stub_datalab('verificacion_ok_uno')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it_should_behave_like 'vehicle cdmx ok'
    it_should_behave_like 'verificacion ok'
    it_should_behave_like 'no circula uno'
    it_should_behave_like 'no adeudos'
  end

  context 'verificacion ok holograma dos' do
    before do
      stub_datalab('verificacion_ok_dos')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it_should_behave_like 'vehicle cdmx ok'
    it_should_behave_like 'verificacion ok'
    it_should_behave_like 'no circula dos'
    it_should_behave_like 'no adeudos'
  end

  context 'verificacion period holograma cero' do
    before do
      stub_datalab('verificacion_period_cero')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it_should_behave_like 'vehicle cdmx ok'
    it_should_behave_like 'verificacion period'
    it_should_behave_like 'no circula cero'
    it_should_behave_like 'no adeudos'
  end

  context 'verificacion period holograma uno' do
    before do
      stub_datalab('verificacion_period_uno')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it_should_behave_like 'vehicle cdmx ok'
    it_should_behave_like 'verificacion period'
    it_should_behave_like 'no circula uno'
    it_should_behave_like 'no adeudos'
  end

  context 'verificacion period holograma dos' do
    before do
      stub_datalab('verificacion_period_dos')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it_should_behave_like 'vehicle cdmx ok'
    it_should_behave_like 'verificacion period'
    it_should_behave_like 'no circula dos'
    it_should_behave_like 'no adeudos'
  end

  context 'verificacion expired' do
    before do
      stub_datalab('verificacion_expired')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it_should_behave_like 'vehicle cdmx ok'
    it_should_behave_like 'verificacion expired'
    it_should_behave_like 'no circula expired'
    it_should_behave_like 'no adeudos'
  end

  context 'verificacion none' do
    before do
      stub_datalab('verificacion_none')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it_should_behave_like 'vehicle cdmx ok'
    it_should_behave_like 'no info'
    it_should_behave_like 'no adeudos'

    context 'with registration date ok' do
      before do
        @vehicle = VehicleCDMX.new({ plate: '123ABC',
                                     registration: { 
                                       day: Date.today.months_ago(2).day,
                                       month: Date.today.months_ago(2).month,
                                       year: Date.today.months_ago(2).year } })
      end
      it_should_behave_like 'vehicle cdmx ok'
      it_should_behave_like 'verificacion first ok'
      it_should_behave_like 'no circula never'
      it_should_behave_like 'no adeudos'
    end
    context 'with registration date expired' do
      before do
        @vehicle = VehicleCDMX.new({ plate: '123ABC',
                                     registration: { 
                                       day: Date.today.months_ago(9).day,
                                       month: Date.today.months_ago(9).month,
                                       year: Date.today.months_ago(9).year } })
      end
      it_should_behave_like 'vehicle cdmx ok'
      it_should_behave_like 'verificacion first expired'
      it_should_behave_like 'no circula expired'
      it_should_behave_like 'no adeudos'
    end
  end

  context 'verificacion rechazo' do
    before do
      stub_datalab('verificacion_rechazo')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it_should_behave_like 'vehicle cdmx ok'
    it_should_behave_like 'no info'
    it_should_behave_like 'no adeudos'

    context 'with registration date ok' do
      before do
        @vehicle = VehicleCDMX.new({ plate: '123ABC',
                                     registration: { 
                                       day: Date.today.months_ago(2).day,
                                       month: Date.today.months_ago(2).month,
                                       year: Date.today.months_ago(2).year } })
      end
      it_should_behave_like 'vehicle cdmx ok'
      it_should_behave_like 'verificacion first ok'
      it_should_behave_like 'no circula never'
      it_should_behave_like 'no adeudos'
    end
    context 'with registration date expired' do
      before do
        @vehicle = VehicleCDMX.new({ plate: '123ABC',
                                     registration: { 
                                       day: Date.today.months_ago(9).day,
                                       month: Date.today.months_ago(9).month,
                                       year: Date.today.months_ago(9).year } })
      end
      it_should_behave_like 'vehicle cdmx ok'
      it_should_behave_like 'verificacion first expired'
      it_should_behave_like 'no circula expired'
      it_should_behave_like 'no adeudos'
    end
  end

  context 'verificacion dos rechazo period' do
    before do
      stub_datalab('verificacion_dos_rechazo_period')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it_should_behave_like 'vehicle cdmx ok'
    it_should_behave_like 'verificacion ok'
    it_should_behave_like 'no circula dos'
    it_should_behave_like 'no adeudos'
  end

  context 'tenencias unpaid verificacion ok holograma dos' do
    before do
      stub_datalab('tenencias_unpaid')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it_should_behave_like 'vehicle cdmx ok'
    it_should_behave_like 'verificacion ok'
    it_should_behave_like 'no circula dos'
    it 'adeudos should return true' do
      expect(subject.adeudos?).to eq(true)      
    end
    it 'infracciones_unpaid should return 0' do
      expect(subject.infracciones_unpaid).to eq(0)
    end
    it 'tenencias_unpaid should return 1' do
      expect(subject.tenencias_unpaid).to eq(1)
    end
  end

  context 'infracciones unpaid verificacion ok holograma dos' do
    before do
      stub_datalab('infracciones_unpaid')
      @vehicle = VehicleCDMX.new({ plate: '123ABC' })
    end
    it_should_behave_like 'vehicle cdmx ok'
    it_should_behave_like 'verificacion ok'
    it_should_behave_like 'no circula dos'
    it 'adeudos should return true' do
      expect(subject.adeudos?).to eq(true)      
    end
    it 'infracciones_unpaid should return 2' do
      expect(subject.infracciones_unpaid).to eq(2)
    end
    it 'tenencias_unpaid should return 0' do
      expect(subject.tenencias_unpaid).to eq(0)
    end
  end
end
