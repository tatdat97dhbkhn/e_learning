class Answer < ApplicationRecord
  belongs_to :question
  has_many :question_logs

  scope :correct_ans, ->{where correct: true}

  ANSWER_ATTRS = %w(content question_id correct).freeze
  scope :question_id, ->{order(question_id: :asc)}

  validates :content, presence: true

  class << self
    def get_correct_answers answers
      @corrects = []

      answers.each do |answer|
        @corrects.push(answer.correct_ans.ids)
      end
      @corrects
    end
  end
end
