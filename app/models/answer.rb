class Answer < ApplicationRecord
  belongs_to :question
  has_many :question_logs

  validates :content, presence: true
end
