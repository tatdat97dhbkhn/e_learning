class Answer < ApplicationRecord
  belongs_to :question
  has_many :question_logs

  ANSWER_ATTRS = %w(content question_id correct).freeze

  validates :content, presence: true
  validates :correct, presence: true
end
