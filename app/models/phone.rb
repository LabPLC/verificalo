class Phone < ActiveRecord::Base
  VALID_PHONE_REGEX = /\A[0-9]{10}\z/i
  validates :number, format: { with: VALID_PHONE_REGEX }
  belongs_to :user
  
  validates :cellphone, inclusion: { in: [ true, false ] }
  validates :morning, inclusion: { in: [ true, false ] }
  validates :afternoon, inclusion: { in: [ true, false ] }
  validates :night, inclusion: { in: [ true, false ] }
  
  validate :schedule_present?
  
  belongs_to :user
  
  def schedule_present?
    if morning.blank? and afternoon.blank? and night.blank?
      errors.add(:schedule, "You must fill in at least one schedule")
    end
  end
end
