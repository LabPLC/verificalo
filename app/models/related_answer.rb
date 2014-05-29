class RelatedAnswer < ActiveRecord::Base
  belongs_to :answer
  belongs_to :related, :class_name => "Answer"
end
