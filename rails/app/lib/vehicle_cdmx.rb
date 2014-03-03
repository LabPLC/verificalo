# -*- coding: utf-8 -*-
require 'httparty'
require 'json'

module VehicleCDMX
  class VehicleCDMX

    # constructor de clase

    def initialize(p)
      if p !~ /\A[a-z0-9]{1,14}\z/i
        @status = 'invalidPlate'
        return
      end
      @plate = p.upcase
      begin
        url = 'http://datos.labplc.mx/movilidad/vehiculos/' + @plate + '.json'
        res = HTTParty.get(url);
      rescue
        @status = 'apiGetError'
        return
      end
      if res.code != 200
        @status = 'apiHttpError'
        return
      end
      begin
        res = JSON.parse(res.body)
        @api = res['consulta']
      rescue
        @status = 'apiJsonError'
        return
      end
      @status = 'ok'
    end

    # accesores basicos

    def error
      if (@status == 'ok')
        return false
      end
      @status
    end

    def plate
      @plate
    end

    def plate_ending
      /\d(?!.*\d)/.match(@plate)[0]
    end

    def plate_ending_str
      plate_ending_str = { 
        '1' => 'uno', '2' => 'dos', '3' => 'tres', '4' => 'cuatro', 
        '5' => 'cinco', '6' => 'seis', '7' => 'siete', '8' => 'ocho',
        '9' => 'nueve', '0' => 'cero' }
      return plate_ending_str[self.plate_ending]
    end

    # verificaciones

    def verificaciones_valid
      if @api['verificaciones'] == 'placa_no_localizada'
        return false
      end
      unless @api['verificaciones'].respond_to?(:each)
        return false
      end
      @api['verificaciones'].collect { |i| 
        i if i['cancelado'] == 'NO'
      }.compact      
    end

    def verificacion_current
      unless self.verificaciones_valid
        return false
      end
      ok = self.verificaciones_valid.collect { |i|
        i if i['resultado'] != 'RECHAZO'
      }.compact
      unless ok.count > 0 
        return false
      end
      sorted = ok.sort { |a, b| 
        _a = Date.strptime(a['vigencia'], "%Y-%m-%d")
        _b = Date.strptime(b['vigencia'], "%Y-%m-%d")
        _b <=> _a
      }
      return sorted[0]
    end
    
    def verificacion_current_vigency
      Date.parse(self.verificacion_current['vigencia'])
    end

    def verificacion_current_period
      (self.verificacion_current_vigency.clone << 2) + 1
    end

    def verificacion_never?
      return true unless self.verificacion_current
      false
    end
    
    def verificacion_expired?
      return false if self.verificacion_never?
      return true if self.verificacion_current_vigency < Date.today
      false
    end

    def verificacion_valid?
      return false if self.verificacion_never?
      return false if self.verificacion_current_vigency < Date.today
      true
    end

    def verificacion_period?
      return false if self.verificacion_never?
      return false if self.verificacion_expired?
      if verificacion_current_period < Date.today
        return true
      end
      false
    end

    def verificacion_ok?
      return false if self.verificacion_never?
      return false if self.verificacion_expired?
      return false if self.verificacion_period?
      true
    end

    # accesores verificacion vigente

    def verificacion_current_vigency_str
      I18n.localize(self.verificacion_current_vigency, :format => :long);
    end

    def verificacion_current_period_str
      I18n.localize(self.verificacion_current_period, :format => :long);
    end

    def verificacion_result
      return false if self.verificacion_never?
      self.verificacion_current['resultado'].downcase
    end

    def verificacion_current_brand_str
      self.verificacion_current['marca'].gsub(/_/, ' ')
    end

    def verificacion_current_model_str
      self.verificacion_current['submarca'].gsub(/_/, ' ')
    end

    def verificacion_current_year_str
      self.verificacion_current['modelo']
    end

    def verificacion_current_vin_str
      self.verificacion_current['vin']
    end

    def verificacion_current_fuel_str
      self.verificacion_current['combustible'].capitalize
    end

    # detalle de verificaciones

    def verificaciones_sorted
      if @api['verificaciones'] == 'placa_no_localizada'
        return false
      end
      unless @api['verificaciones'].respond_to?(:each)
        return false
      end
      sorted = @api['verificaciones'].sort { |a, b| 
        if a == b
          _a = a['hora_verificacion']
          _b = b['hora_verificacion']
        else
          _a = Date.strptime(a['fecha_verificacion'], "%Y-%m-%d")
          _b = Date.strptime(b['fecha_verificacion'], "%Y-%m-%d")
        end
        _b <=> _a
      }
      sorted.collect { |v|
        r = OpenStruct.new()
        r.date = I18n.localize(Date.parse(v['fecha_verificacion']), :format => :default);
        r.time = v['hora_verificacion'].gsub(/:\d\d$/, '');
        r.verificentro = v['verificentro']
        r.line = v['linea']
        r.cert = v['certificado']
        r.cancel = v['cancelado'] == 'SI' ? true : false
        r.vigency = I18n.localize(Date.parse(v['vigencia']), :format => :default);
        r.result = v['resultado']
        r.reject = v['casua_rechazo']
        r
      }
    end

    # hoy no circula

    def no_circula_weekday
      plate_no_circula_weekday = { 
        '1' => 'jueves', '2' => 'jueves',
        '3' => 'miércoles', '4' => 'miércoles',
        '5' => 'lunes', '6' => 'lunes',
        '7' => 'martes', '8' => 'martes',
        '9' => 'viernes', '0' => 'viernes' }
      return plate_no_circula_weekday[self.plate_ending]
    end

    def no_circula_weekend
      plate_no_circula_weekend = { 
        '1' => 'cuarto', '2' => 'cuarto',
        '3' => 'tercer', '4' => 'tercer',
        '5' => 'primer', '6' => 'primer',
        '7' => 'segundo', '8' => 'segundo',
        '9' => 'quinto', '0' => 'quinto' }
      return plate_no_circula_weekend[self.plate_ending] + ' sábado'
    end

    # infracciones

    def infracciones_unpaid
      @api['infracciones'].count { |i| i['situacion'] != 'Pagada' }
    end

    # tenencias

    def tenencias_unpaid
      if @api['tenencias']['tieneadeudos'] == '1'
        return @api['tenencias']['adeudos'].split(/,/).count
      end
      return 0
    end
    
    def tenencias_unpaid_str
      unpaid = @api['tenencias']['adeudos'].split(/,/)
      if unpaid.count < 1
        return false
      end
      if unpaid.count > 1
        return [unpaid[0...-1].join(', '), unpaid.last].join(' y ')
      else
        return unpaid[0]
      end
    end

  end
end
