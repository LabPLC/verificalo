require 'httparty'

module VehicleCDMX

  class VehicleCDMX

    def initialize(p)
      if p !~ /^[a-zA-Z0-9]{1,14}$/
        @status = 'invalidPlate'
        return false
      end
      @plate = p.upcase
      begin
        url = 'http://datos.labplc.mx/movilidad/vehiculos/' + @plate + '.json'
        res = HTTParty.get(url);
      rescue
        @status = 'apiGetError'
        return false
      end
      if res.code != 200
        @status = 'apiHttpError'
        return false
      end
      @api = res.body
      @status = 'ok'
      return true
    end
    
    def plate
      return @placa
    end
    
    def status
      return @status
    end
    
    def api
      return @api
    end

  end

end
