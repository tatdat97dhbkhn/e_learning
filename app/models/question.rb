class Question < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :question_logs

  accepts_nested_attributes_for :answers, allow_destroy: true,
    reject_if: proc{|a| a[:content].blank?}

  QUESTION_ATTRS = %w(meaning content category_id).freeze

  validates :meaning, presence: true,
    length: {maximum: Settings.question.length.max_meaning}
  validates :content, presence: true,
    length: {maximum: Settings.question.length.max_content}

  scope :get_ques_by_ids, ->(ids){where id: ids}
  scope :using, ->(flag){where used: flag}

  class << self
    def get_questions question_logs
      types = []
      pre_ques = question_logs.last

      question_logs.preload(:question).each do |ql|
        next if pre_ques == ql.question
        pre_ques = ql.question
        types.push pre_ques.answers.correct_ans.size
      end
      types
    end
  end

  def valid_question?
    correct_ans = answers.correct_ans.size
    return if correct_ans.zero? || correct_ans == answers.size
    true
  end
end
