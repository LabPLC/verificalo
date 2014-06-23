# -*- coding: utf-8 -*-
require 'httparty'
require 'json'
require 'htmlentities'

module VehicleCDMX
  class VehicleCDMX

    # constructor de clase

    def initialize (params)
      if self.validate(params) && self.extra(params)
        self.api
      end
    end

    # validacion de parametros

    def validate (params)
      unless params['plate']
        @status = 'INVALID_PLATE'
        return false
      end
      params['plate'].gsub!(/[^0-9a-z ]/i, '')
      if params['plate'] !~ /\A[1-9][0-9][0-9][a-z][a-z][a-z]\z/i
        @status = 'INVALID_PLATE'
        return false
      end
      @plate = params['plate'].upcase
      true
    end

    # parametros extra

    def extra (params)
      if params['vin']
        @vin = params['vin'].upcase
      end
      if params['registration']
        @registration = OpenStruct.new
        @registration.y = params['registration']['year']
        @registration.m = params['registration']['month']
        @registration.d = params['registration']['day']
      end
      true
    end

    # consulta api

    def api
      begin
        url = 'http://datos.labplc.mx/movilidad/vehiculos/' + @plate + '.json'
        res = HTTParty.get(url);
      rescue
        @status = 'API_GET_ERROR'
        return false
      end
      if res.code != 200
        @status = 'API_HTTP_ERROR'
        return false
      end
      begin
        res = JSON.parse(res.body)
        @api = res['consulta']
      rescue
        @status = 'API_JSON_ERROR'
        return false
      end
      unless @api['verificaciones'].is_a?(Array)
        @status = 'API_VERIFICACIONES_ERROR'
        return false
      end
      unless @api['infracciones'].is_a?(Array)
        @status = 'API_INFRACCIONES_ERROR'
        return false
      end
      unless @api['tenencias'].is_a?(Hash)
        @status = 'API_TENENCIAS_ERROR'
        return false
      end
      @status = 'OK'
      true
    end

    # accesores basicos

    def error
      return false if @status == 'OK'
      @status
    end

    def plate
      return false if self.error
      @plate
    end
    
    def plate_last_digit
      return false if self.error
      /\d(?!.*\d)/.match(@plate)[0]
    end

    def plate_last_digit_str
      return false if self.error
      plate_last_digit_str = {
        '1' => 'uno', '2' => 'dos', '3' => 'tres', '4' => 'cuatro', 
        '5' => 'cinco', '6' => 'seis', '7' => 'siete', '8' => 'ocho',
        '9' => 'nueve', '0' => 'cero' }
      return plate_last_digit_str[self.plate_last_digit]
    end

    # accesores vin

    def user_vin?
      return true if @vin
      false
    end

    def user_vin
      return false unless self.user_vin?
      @vin
    end

    def user_vin= (v)
      @vin = v.upcase
    end
    
    def user_vin_valid?
      return false unless self.user_vin?
      if self.user_vin =~ /\A[a-z0-9]+\z/i
        return true
      end
      false
    end

    # accesores fecha de registro

    def registration_date?
      return true if @registration
      false
    end

    def registration_date
      return false unless self.registration_date?
      begin
        return Date.new(@registration.y.to_i,
                        @registration.m.to_i,
                        @registration.d.to_i)
      rescue
        return false
      end
      false
    end

    def registration_date= (s)
      date = Date.iso8601(s)
      @registration = OpenStruct.new
      @registration.y = date.year
      @registration.m = date.month
      @registration.d = date.day
    end

    def registration_date_valid?
      return false unless self.registration_date?
      return false unless self.registration_date
      return false if self.registration_date > Date.today
      true
    end

    def registration_date_str
      return false unless self.registration_date?
      I18n.localize(self.registration_date, :format => :long);
    end

    # verificaciones
    
    def verificaciones?
      unless @api['verificaciones'].is_a?(Array)
        return false
      end
      unless @api['verificaciones'].count > 0
        return false
      end
      true
    end

    def verificaciones
      return false unless self.verificaciones?
      if self.user_vin_valid?
        v = @api['verificaciones'].collect { |i| 
          i if i['vin'].upcase == self.user_vin
        }.compact
      else
        v = @api['verificaciones']
      end
      v.collect { |i| 
        i if i['vin'].upcase != 'DESCONOCIDO'
      }.compact.sort { |a, b| 
        _a = a['fecha_verificacion'].gsub(/-/, '') + a['hora_verificacion'].gsub(/:/, '')
        _b = b['fecha_verificacion'].gsub(/-/, '') + b['hora_verificacion'].gsub(/:/, '')
        _b <=> _a
      }
    end
    
    def verificaciones_vins
      return false unless self.verificaciones?
      if self.user_vin_valid?
        return [ self.user_vin ]
      else
        return @api['verificaciones'].collect { |i|
          i['vin'] if i['vin'].upcase != 'DESCONOCIDO'
        }.compact.uniq
      end
    end

    def verificaciones_vins?
      return false unless self.verificaciones_vins
      return true if self.verificaciones_vins.count > 1
      false
    end
    
    def verificaciones_valid
      return false unless self.verificaciones?
      self.verificaciones.collect { |i|
        i if i['cancelado'] == 'NO'
      }.compact
    end

    def verificaciones_valid?
      return false unless self.verificaciones?
      return false unless self.verificaciones_valid
      if self.verificaciones_valid.count > 0
        return true
      end
      false
    end

    def verificaciones_approved
      return false unless self.verificaciones_valid?
      self.verificaciones_valid.collect { |i|
        i if i['resultado'] != 'RECHAZO'
      }.compact      
    end

    def verificaciones_approved?
      return false unless self.verificaciones_valid?
      if self.verificaciones_approved.count > 0
        return true
      end
      false
    end

    def verificacion_current
      return false unless self.verificaciones_valid?
      return self.verificaciones_valid[0]
    end

    def verificacion_current?
      return false unless self.verificacion_current
      true
    end

    def verificacion_current_vigency
      return false unless self.verificacion_current?
      Date.parse(self.verificacion_current['vigencia'])
    end

    def verificacion_current_period
      return false unless self.verificacion_current?
      (self.verificacion_current_vigency.clone << 2) + 1
    end
    
    def verificacion_expired?
      return false unless self.verificaciones_approved?
      return true if self.verificacion_current_vigency < Date.today
      false
    end

    def verificacion_valid?
      return false unless self.verificacion_current?
      return false if self.verificacion_current_vigency < Date.today
      true
    end

    def verificacion_period?
      return false unless self.verificaciones_approved?
      return false if self.verificacion_expired?
      if verificacion_current_period < Date.today
        return true
      end
      false
    end

    def verificacion_ok?
      return false unless self.verificaciones_approved?
      return false if self.verificacion_expired?
      return false if self.verificacion_period?
      true
    end

    # accesores verificacion vigente

    def verificacion_current_vigency_str
      return false unless self.verificacion_current?
      I18n.localize(self.verificacion_current_vigency, :format => :long);
    end

    def verificacion_current_period_str
      return false unless self.verificaciones_approved?
      I18n.localize(self.verificacion_current_period, :format => :long);
    end

    def verificacion_result
      return false unless self.verificacion_current?
      self.verificacion_current['resultado'].downcase
    end

    def verificacion_current_brand_str
      return false unless self.verificacion_current?
      self.verificacion_current['marca'].gsub(/_/, ' ')
    end

    def verificacion_current_model_str
      return false unless self.verificacion_current?
      self.verificacion_current['submarca'].gsub(/_/, ' ')
    end

    def verificacion_current_year_str
      return false unless self.verificacion_current?
      self.verificacion_current['modelo']
    end

    def verificacion_current_vin_str
      return false unless self.verificacion_current?
      self.verificacion_current['vin']
    end

    # detalle de verificaciones

    def verificaciones_all
      return false unless self.verificaciones?
      self.verificaciones.collect { |v|
        r = OpenStruct.new
        r.date = I18n.localize(Date.parse(v['fecha_verificacion']), :format => :default);
        r.time = v['hora_verificacion'].gsub(/:\d\d$/, '');
        r.verificentro = v['verificentro']
        r.line = v['linea']
        r.fuel = v['combustible'].capitalize
        r.cert = v['certificado']
        r.cancel = v['cancelado'] == 'SI' ? true : false
        r.vigency = I18n.localize(Date.parse(v['vigencia']), :format => :default);
        r.result = v['resultado']
        r.reject = v['casua_rechazo']
        r
      }
    end

    # accesores primera verificacion

    def verificacion_first_period_end
      return false unless self.registration_date_valid? 
      self.registration_date + 180
    end

    def verificacion_first_period_ok?
      return false unless self.registration_date_valid?
      if verificacion_first_period_end > Date.today
        return true
      end
      false
    end
    
    def verificacion_first_period_expired?
      return false unless self.registration_date_valid?
      return true unless self.verificacion_first_period_ok?
      false
    end

    def verificacion_first_period_end_str
      return false unless self.registration_date_valid?
      I18n.localize(self.verificacion_first_period_end, :format => :long);
    end

    # hoy no circula

    def no_circula_weekday
      return false if self.error
      plate_no_circula_weekday = { 
        '1' => 'jueves', '2' => 'jueves',
        '3' => 'miércoles', '4' => 'miércoles',
        '5' => 'lunes', '6' => 'lunes',
        '7' => 'martes', '8' => 'martes',
        '9' => 'viernes', '0' => 'viernes' }
      return plate_no_circula_weekday[self.plate_last_digit]
    end

    def no_circula_weekend
      return false if self.error
      plate_no_circula_weekend = { 
        '1' => 'cuarto', '2' => 'cuarto',
        '3' => 'tercer', '4' => 'tercer',
        '5' => 'primer', '6' => 'primer',
        '7' => 'segundo', '8' => 'segundo',
        '9' => 'quinto', '0' => 'quinto' }
      return plate_no_circula_weekend[self.plate_last_digit] + ' sábado'
    end

    # infracciones

    def infracciones?
      unless @api['infracciones'].is_a?(Array)
        return false
      end
      unless @api['infracciones'].count > 0
        return false
      end
      true
    end

    def infracciones_unpaid
      return 0 unless self.infracciones?
      @api['infracciones'].count { |i| i['situacion'] != 'Pagada' }
    end

    def infracciones_all
      return false unless self.infracciones?
      unless @api['infracciones'].count > 0
        return false
      end
      @api['infracciones'].sort { |a, b| 
        _a = Date.strptime(a['fecha'], "%Y-%m-%d")
        _b = Date.strptime(b['fecha'], "%Y-%m-%d")
        _b <=> _a
      }.collect { |i|
        coder = HTMLEntities.new
        r = OpenStruct.new
        r.date = I18n.localize(Date.parse(i['fecha']), :format => :default);
        r.id = i['folio']
        r.cause = coder.decode(i['motivo'])
        r.basis = coder.decode(i['fundamento'])
        r.sanction = coder.decode(i['sancion'])
        r.status = coder.decode(i['situacion'])
        r
      }
    end

    # tenencias

    def tenencias?
      unless @api['tenencias'].is_a?(Hash)
        return false
      end
      true
    end

    def tenencias_unpaid
      return false unless self.tenencias?
      if @api['tenencias']['tieneadeudos'] == '1'
        return @api['tenencias']['adeudos'].split(/,/).count
      end
      return 0
    end
    
    def tenencias_unpaid_str
      return false unless self.tenencias?
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
