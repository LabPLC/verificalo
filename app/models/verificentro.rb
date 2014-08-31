class Verificentro < ActiveRecord::Base
  validates :number, :name, :address, presence: true
  validates :delegacion, presence: true
  validates :lat, :lon, numericality: true
  validates :suspended, inclusion: { in: [ true, false ] }

  belongs_to :delegacion
  reverse_geocoded_by :lat, :lon

  def self.not_suspended
    self.where(suspended: false)
  end
end
