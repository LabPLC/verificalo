class User < ActiveRecord::Base
  VALID_PLATE_REGEX = /\A[1-9][0-9][0-9][a-z][a-z][a-z]\z/i
  validates :plate, presence: true, format: { with: VALID_PLATE_REGEX }
  
  validates :adeudos, inclusion: { in: [ true, false ] }
  validates :verificacion, inclusion: { in: [ true, false ] }
  validates :no_circula_weekday, inclusion: { in: [ true, false ] }
  validates :no_circula_weekend, inclusion: { in: [ true, false ] }
  
  validate :notices_present?
  
  has_one :email, :dependent => :destroy
  has_one :phone, :dependent => :destroy
  
  before_validation {
    self.plate = self.plate.gsub(/[^0-9a-z ]/i, '').strip if self.plate
  }

  before_save {
    self.plate = self.plate.upcase
  }
  
  def notices_present?
    if adeudos.blank? and verificacion.blank? and 
        no_circula_weekday.blank? and no_circula_weekend.blank?
      errors.add(:notices, "You must fill in at least one notice")
    end
  end

  def destroy_outdated
    if self.email
      User.joins(:email)
        .where.not(users: { id: self.id })
        .where(users: { plate: self.plate })
        .where(emails: { address: self.email.address })
        .destroy_all
    elsif self.phone
      User.joins(:phone)
        .where.not(users: { id: self.id })
        .where(users: { plate: self.plate })
        .where(phones: { number: self.phone.number, cellphone: self.phone.cellphone })
        .destroy_all
    end
  end

  def self.are_active
    self.where.not(confirmed_at: nil).where(declined_at: nil)
  end
end
