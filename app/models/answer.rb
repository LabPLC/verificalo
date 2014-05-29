class Answer < ActiveRecord::Base
  belongs_to :category
  belongs_to :contact
  has_many :related_answer
  has_many :answers, :through => :related_answer
end
