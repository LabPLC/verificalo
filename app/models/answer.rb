class Answer < ActiveRecord::Base
  belongs_to :category
  belongs_to :contact
end
