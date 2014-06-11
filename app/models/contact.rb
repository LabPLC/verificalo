class Contact < ActiveRecord::Base
  validates :name, presence: true
  validates :lat, :lon, numericality: { allow_nil: true }
  
  has_many :answers, inverse_of: :contact
end
