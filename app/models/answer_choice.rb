class AnswerChoice < ActiveRecord::Base
  attr_accessible :question_id, :answer_text
  validates :question_id, :presence => true

  belongs_to(
  :question,
  :primary_key => :id,
  :foreign_key => :question_id,
  :class_name => 'Question'
  )

  has_many(
  :responses,
  :primary_key => :id,
  :foreign_key => :answer_choice_id,
  :class_name => 'Response'
  )

end