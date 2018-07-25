class Answer < ApplicationRecord
  belongs_to :question
  has_many :question_logs, dependent: :destroy

  scope :correct_ans, ->{where correct: true}

  ANSWER_ATTRS = %w(content question_id correct).freeze

  validates :content, presence: true

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
