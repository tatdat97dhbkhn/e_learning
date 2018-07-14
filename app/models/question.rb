class Question < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :question_logs, dependent: :destroy

  validates :content, presence: true
end
