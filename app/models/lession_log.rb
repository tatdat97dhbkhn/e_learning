class LessionLog < ApplicationRecord
  belongs_to :user
  belongs_to :lession
  has_many :question_logs, dependent: :destroy
end
