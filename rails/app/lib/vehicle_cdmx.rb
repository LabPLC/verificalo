require 'httparty'
require 'json'

module VehicleCDMX

  class VehicleCDMX

    # constructor de clase

    def initialize(p)
      if p !~ /^[a-zA-Z0-9]{1,14}$/
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

    # verificaciones
    
    def emissions_found
      if @api['verificaciones'] == 'placa_no_localizada'
        return false
      end
      true
    end

    def emissions_valid
      unless @api['verificaciones'].respond_to?(:each)
        return false
      end
      @api['verificaciones'].collect { |i| 
        i if i['cancelado'] == 'NO'
      }.compact
    end
    
    def emissions_vigency
      valid = self.emissions_valid
      unless valid.respond_to?(:each) && valid.count > 0
        return false
      end
      sorted = valid.sort { |a, b| 
        _a = Date.strptime(a['vigencia'], "%Y-%m-%d")
        _b = Date.strptime(b['vigencia'], "%Y-%m-%d")
        _b <=> _a
      }
      return sorted
    end

    # infracciones

    def unpaid_tickets
      @api['infracciones'].count { |i| i['situacion'] != 'Pagada' }
    end

    # tenencias

    def unpaid_taxes
      if @api['tenencias']['tieneadeudos'] == '1'
        return @api['tenencias']['adeudos'].split(/,/).count
      end
      return 0
    end
    
    def unpaid_taxes_sentence
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
    
    # test

    def test
      return
    end
    
  end

end
