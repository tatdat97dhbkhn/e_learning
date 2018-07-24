class QuestionLog < ApplicationRecord
  belongs_to :lesson_log
  belongs_to :question
  belongs_to :answer
end
