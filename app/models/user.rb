class User < ActiveRecord::Base  
  VALID_PLATE_REGEX = /\A[1-9][0-9][0-9][a-z][a-z][a-z]\z/i
  validates :plate, presence: true, format: { with: VALID_PLATE_REGEX }

  validates :via, presence: true
  validates_inclusion_of :via, in: %w(EMAIL PHONE)  

  validates :destination, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :destination, format: { with: VALID_EMAIL_REGEX }, if: lambda { self.via == 'EMAIL' }
  VALID_PHONE_REGEX = /\A[0-9]{10,11}\z/i
  validates :destination, format: { with: VALID_PHONE_REGEX }, if: lambda { self.via == 'PHONE' }

  before_validation {
    self.plate = self.plate.gsub(/[^0-9a-z ]/i, '').strip if self.plate
    if self.destination
      self.destination = self.destination.strip if self.via == 'EMAIL'
      self.destination = self.destination.gsub(/[^0-9]/, "") if self.via == 'PHONE'
    end
  }

  before_save {
    self.plate = self.plate.upcase
    self.destination = self.destination.downcase
  }

  has_many :settings
end
