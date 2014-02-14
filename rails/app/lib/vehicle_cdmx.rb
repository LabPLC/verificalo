require 'httparty'
require 'json'

module VehicleCDMX

  class VehicleCDMX

    def initialize(p)
      if p !~ /^[a-zA-Z0-9]{1,14}$/
        @status = 'invalidPlate'
        return
      end
      @plate = p.upcase
      begin
        url = 'http://dev.datos.labplc.mx/movilidad/vehiculos/' + @plate + '.json'
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

    def error
      if (@status == 'ok')
        return false
      end
      @status
    end

    def plate
      @plate
    end

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
    
    def tickets
      @api['infracciones'].count
    end
    
    def unpaid_tickets
      @api['infracciones'].count{ |i| i['situacion'] != 'Pagada' }
    end
    
    def test
      return
    end
    
  end

end
