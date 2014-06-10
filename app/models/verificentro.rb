class Verificentro < ActiveRecord::Base
  validates :number, :name, :address, presence: true
  validates :delegacion, presence: true
  validates :lat, :lon, numericality: true

  belongs_to :delegacion
  reverse_geocoded_by :lat, :lon
end
