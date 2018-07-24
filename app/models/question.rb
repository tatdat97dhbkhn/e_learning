class Question < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :question_logs, dependent: :destroy

  QUESTION_ATTRS = %w(meaning content category_id).freeze

  validates :meaning, presence: true
  validates :content, presence: true

  class << self
    def get_questions_by_question_logs question_logs
      questions = Question.where(id: question_logs.select(:question_id)).preload(:answers)
    end
  end
end
