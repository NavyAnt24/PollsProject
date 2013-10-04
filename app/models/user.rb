class User < ActiveRecord::Base
  attr_accessible :user_name

  validates :user_name, :uniqueness => true, :presence => true

  has_many( :authored_polls,
  :primary_key => :id,
  :foreign_key => :author_id,
  :class_name => "Poll"
  )

  has_many( :responses,
  :primary_key => :id,
  :foreign_key => :user_id,
  :class_name => "Response"
  )

  def completed_polls
    answered_questions = self.responses.map(&:question)
    poll_question_count = Hash.new(0)

    answered_questions.each do |answered_question|
      poll_question_count[answered_question.poll] += 1
    end

    completed_polls = []
    poll_question_count.keys.each do |poll|
      if poll.questions.length == poll_question_count[poll]
        completed_polls << poll.title
      end
    end

    completed_polls
  end

  def uncompleted_polls
    answered_questions = self.responses.map(&:question)
    poll_question_count = Hash.new(0)

    answered_questions.each do |answered_question|
      poll_question_count[answered_question.poll] += 1
    end

    completed_polls = []
    poll_question_count.keys.each do |poll|
      if poll.questions.length != poll_question_count[poll]
        completed_polls << poll.title
      end
    end

    completed_polls
  end
end