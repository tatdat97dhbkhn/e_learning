class LessonLog < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  has_many :question_logs, dependent: :destroy

  scope :order_date, ->(cond){order updated_at: cond}
  scope :current, ->(current_user){where(user_id: current_user)}
  scope :pass_lesson, ->{where(pass: true)}

  after_create :create_question_log

  def create_question_log
    QuestionLog.create_question_logs
  end

  def update_result status
    if status.eql? I18n.t("save")
      update_attributes saved: true
    else
      update_pass
    end
  end

  def update_pass
    update_attributes pass: get_result > Settings.number.enought_to_pass
  end

  def get_result
    question_logs = self.question_logs
    total = Question.get_ques_by_ids(question_logs.pluck :question_id).size
    corrects = get_question_logs_each_question question_logs
    corrects.delete nil
    score = corrects.size * Settings.number.one_float / total
  end

  def get_question_logs_each_question question_logs
    prev = question_logs.last.question_id
    corrects = []
    question_logs.each_with_index do |ql, j|
      next if ql.question_id == prev
      prev = ql.question_id
      num = question_logs.select{|q| q.question_id == prev}.size
      corrects.push question_result question_logs[j...j+num]
    end
    corrects
  end

  def question_result question_logs
    choose = []
    correct = []
    question_logs.each do |ql|
      choose.push ql.answer_id if !ql.number.zero?
      correct.push ql.answer_id if ql.answer.correct
    end
    true if choose.sort == correct.sort
  end

  class << self
    def get_lesson_log question_logs
      @questions = []
      @answers = []

      question_logs.each do |question_log|
        @questions.push question_log.question.id
        @answers.push question_log.question.answers.order("RAND()")
      end

      [@questions, @answers]
    end

    def get_scores lesson_logs
      results = []

      lesson_logs.preload(:question_logs).each do |ll|
        question_log = ll.question_logs
        total = Question.get_ques_by_ids(question_log.pluck :question_id).size
        results.push (unless ll.pass.nil?
                       "#{(ll.get_result * total).to_i} / #{total}"
                     else
                       ""
                     end)
      end
      results
    end

    def get_lessons_user user
      user.lesson_logs.order_date(:desc).includes :lesson
    end
  end

  private

  attr_reader :lesson_log
end
