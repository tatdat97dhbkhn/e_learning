class LessionLog < ApplicationRecord
  belongs_to :user
  belongs_to :lession
  has_many :question_logs, dependent: :destroy

  def create_lessionlog
    category = lession.course.category
    @questions = category.questions.order("RAND()").first Settings.lession.page

    @questions.each do |question|
      question_logs.create question_id: question.id,
        answer_id: Settings.question.answer_default
    end
  end

  class << self
    def get_lessionlog question_logs
      @questions = []
      @answers = []

      question_logs.each do |question_log|
        @questions << question_log.question
        @answers << question_log.question.answers.order("RAND()")
      end

      [@questions, @answers]
    end
  end
end
