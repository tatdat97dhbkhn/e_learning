class QuestionLog < ApplicationRecord
  belongs_to :lesson_log
  belongs_to :question
  belongs_to :answer

  class << self
    def create_question_logs
      ls = LessonLog.last
      category = ls.lesson.course.category
      max_question = (Settings.number.zero...Settings.lesson.page)

      category.questions.shuffle[max_question].each do |question|
        question.answers.shuffle.each do |answer|
          ls.question_logs.create question_id: question.id,
            answer_id: answer.id
        end
      end
    end
  end
end
