class Answer < ActiveRecord::Base
  validates :url, :title, :body, presence: true
  validates :category, presence: true
  validates :views, :positive, :negative, numericality: { only_integer: true, 
    greater_than_or_equal_to: 0 }

  belongs_to :category, inverse_of: :answers
  belongs_to :contact, inverse_of: :answers
  belongs_to :related_1, class_name: 'Answer'
  belongs_to :related_2, class_name: 'Answer'
  belongs_to :related_3, class_name: 'Answer'
  belongs_to :related_4, class_name: 'Answer'
  belongs_to :related_5, class_name: 'Answer'

  searchkick language: 'Spanish', suggest: [ 'title' ]
end
