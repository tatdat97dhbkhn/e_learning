class Question < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :question_logs

  QUESTION_ATTRS = %w(meaning content category_id).freeze

  validates :meaning, presence: true,
    length: {maximum: Settings.question.length.max_meaning}
  validates :content, presence: true,
    length: {maximum: Settings.question.length.max_content}

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
