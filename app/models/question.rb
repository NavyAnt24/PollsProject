class Question < ActiveRecord::Base
  attr_accessible :question_text, :poll_id
  validates :poll_id, :presence => true

  has_many(
  :answer_choices,
  :primary_key => :id,
  :foreign_key => :question_id,
  :class_name => 'AnswerChoice'
  )

  belongs_to(
  :poll,
  :primary_key => :id,
  :foreign_key => :poll_id,
  :class_name => 'Poll'
  )

  has_many :responses, :through => :answer_choices, :source => :responses

  def results
    responses = self.responses.includes(:answer_choices)
    answer_choice_count = Hash.new(0)
    answers = self.answer_choices.map(&:answer_text)
    answers.each do |answer|
      answer_choice_count[answer] = 0
    end

    responses.each do |response|
      answer_choice_count[response.answer_choices.answer_text] += 1
    end
    answer_choice_count
  end

end