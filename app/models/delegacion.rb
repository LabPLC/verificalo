class Delegacion < ActiveRecord::Base
  has_many :verificentros, inverse_of: :delegacion
end
