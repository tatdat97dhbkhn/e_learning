class Question < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :question_logs, dependent: :destroy

  QUESTION_ATTRS = %w(meaning content category_id).freeze

  validates :content, presence: true

  scope :get_ques_by_ids, ->(ids){where id: ids}

  class << self
    def get_questions question_logs
      ids = question_logs.select(:question_id)
      questions = Question.get_ques_by_ids(ids).preload(:answers)
      answers = []
      types = []

      questions.each do |q|
        types.push q.answers.select{|a| a.correct == true}.size
      end
      [questions, types]
    end
  end
end
