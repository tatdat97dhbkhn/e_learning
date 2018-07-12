class QuestionLog < ApplicationRecord
  belongs_to :lession_log
  belongs_to :question
  belongs_to :answer
end
