class Answer < ActiveRecord::Base
  belongs_to :category
  belongs_to :contact
  belongs_to :related_1, class_name: 'Answer'
  belongs_to :related_2, class_name: 'Answer'
  belongs_to :related_3, class_name: 'Answer'
  belongs_to :related_4, class_name: 'Answer'
  belongs_to :related_5, class_name: 'Answer'
end
