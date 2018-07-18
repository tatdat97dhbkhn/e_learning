class LessionLog < ApplicationRecord
  belongs_to :user
  belongs_to :lession
  has_many :question_logs, dependent: :destroy

  scope :finished, ->{where.not pass: nil}

  def create_lession_log
    category = lession.course.category
    @questions = category.questions.order("RAND()").first Settings.lession.page

    @questions.each do |question|
      question_logs.create question_id: question.id,
        answer_id: Settings.question.answer_default
    end
  end

  def update_result question_logs
    if question_logs == Settings.number.zero
      update_attributes pass: false
    else
      total = self.question_logs.count
      correct = Settings.number.zero

      question_logs.keys.each do |question_log_id|
        quession_log = QuestionLog.find_by id: question_log_id
        quession_log.update_attributes answer_id: question_logs[question_log_id]
        correct += Settings.number.one if quession_log.answer.correct
      end

      update_pass correct, total
    end
  end

  class << self
    def get_lession_log question_logs
      @questions = []
      @answers = []

      question_logs.each do |question_log|
        @questions << question_log.question
        @answers << question_log.question.answers.order("RAND()")
      end

      [@questions, @answers]
    end

    def get_result lession_logs
      question_logs = []
      lession_logs.each do |lession_log|
        question_logs.push lession_log.question_logs
      end
      correct = Settings.number.zero
      results = []
      question_logs.each do |question_log|
        question_log.each do |q|
          correct += 1 if q.answer.correct
        end
        results.push "#{correct}/#{question_log.count}"
      end
      return results
    end
  end

  private

  def update_pass correct, total
    if (correct * Settings.number.one_float / total) >
       Settings.number.enought_to_pass
      update_attributes pass: true
    else
      update_attributes pass: false
    end
  end
end
