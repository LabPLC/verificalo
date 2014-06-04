class Category < ActiveRecord::Base
  has_many :answers
  
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
