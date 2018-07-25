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
        next unless question.valid_question?
        question.answers.shuffle.each do |answer|
          ls.question_logs.create question_id: question.id,
            answer_id: answer.id, number: Settings.number.zero
        end
      end
    end
  end
  
  def update_result
    if question.answers.select{|a| a.correct == true}.size <
       Settings.number.two
      update_single
    else
      update_multiple
    end
  end

  private

  def update_single
    question_logs = QuestionLog.where(lesson_log_id: lesson_log_id,
      question_id: question_id,
      number: Settings.number.one).update number: Settings.number.zero
    update_attributes number: Settings.number.one
  end

  def update_multiple
    update_attributes number: if number.zero?
                                Settings.number.one
                              else
                                Settings.number.zero
                              end
  end
end
