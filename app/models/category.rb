class Category < ActiveRecord::Base
  validates :url, :name, presence: true
  validates :priority, numericality: { only_integer: true, allow_nil: true, greater_than: 0 }

  has_many :answers, inverse_of: :category
  
  def sort_answers
    self.answers.order("positive ASC, negative DESC, views ASC, title")
  end
  
  def top_answers(n = 3)
    self.sort_answers.limit(n)
  end
  
  def more_answers?(n = 3)
    return true if self.sort_answers.count > self.top_answers.count
    false
  end
end
