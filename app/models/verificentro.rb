class Verificentro < ActiveRecord::Base
  belongs_to :delegacion
  reverse_geocoded_by :lat, :lon
end
