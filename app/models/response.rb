class Response < ActiveRecord::Base
  attr_accessible :answer_choice_id, :user_id
  validates :answer_choice_id, :user_id, :presence => true
  validate :respondent_has_not_already_answered_question

  belongs_to(
    :answer_choice,
    :primary_key => :id,
    :foreign_key => :answer_choice_id,
    :class_name => 'AnswerChoice'
  )

  belongs_to(
    :respondent,
    :primary_key => :id,
    :foreign_key => :user_id,
    :class_name => 'User'
  )

  has_one :question, :through => :answer_choice, :source => :question

  def respondent_has_not_already_answered_question
    # user_ids = self.question.responses.pluck(:user_id)
    # if user_ids.include?(self.user_id)
    #   errors[:response] << "Can't respond to the same question twice."
    # end

    responses = Response.find_by_sql([<<-SQL, self.answer_choice_id, self.user_id])
    SELECT *
    FROM
      answer_choices
    JOIN
      responses
    ON
      answer_choices.id = responses.answer_choice_id
    WHERE
    question_id IN
      (SELECT question_id
      FROM answer_choices
      WHERE answer_choices.id = ?)
    AND responses.user_id = ?
    SQL

      p responses.length
      p responses[0].user_id

    if responses.length == 1
      if responses[0].id != self.id
        errors[:response] << "Can't respond to the same question twice."
      end
    end
  end

  def author_cant_respond_to_own_poll
    if  self.question.poll.author_id == self.user_id
      errors[:response] << "The creator of the poll can't vote."
    end
  end
end