class Answer < ApplicationRecord
  belongs_to :question
  has_many :question_logs

  scope :correct_ans, ->{where correct: true}

  ANSWER_ATTRS = %w(id content correct _destroy).freeze

  validates :content, presence: true,
    length: {maximum: Settings.answer.length.max_content}

  class << self
    def get_correct_answers questions
      corrects = []

      questions.preload(:answers).each do |q|
        corrects.push q.answers.select{|a| a.correct == true}
      end
      corrects.flatten!
    end
  end
end
