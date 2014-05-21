class Email < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :address, format: { with: VALID_EMAIL_REGEX }

  belongs_to :user
end
