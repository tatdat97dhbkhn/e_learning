class FiltersController < ApplicationController
  before_action :logged_in_user,
    only: %i(listword listwordcategory listwordalphabet listword_learned)
  skip_before_action :is_admin?

  def listword
    @answers = Answer.where correct: Settings.number.one
  end

  def listword_category
    @category = Category.find_by id: params[:id]
    @answers = @category.answers.where correct: true
  end

  def listword_alphabet
    @answers = Answer.where(correct: Settings.number.one).order "content ASC"
  end

  def listword_learned
    @status = params[:status]
    @lession_logs = LessionLog.where user_id: current_user.id

    @question_logs = []
    @lession_logs.each do |lession_log|
      @question_logs.push QuestionLog.where lession_log_id: lession_log.id
    end

    @learned = []
    @answer = []
    @question_logs.each do |question_log|
      question_log.each do |ql|
        @answer.push Answer.where id: ql.answer_id
      end
    end

    @answer_true = []
    @answer.each do |a|
      @answer_true.push a if a[0].correct
    end

    @arr = []
    @arr = @answer_true.flatten.uniq

    @unlearned = []
    return unless @status == Settings.status_unlearn
    @unlearned.push Answer.where.not id: @arr
  end
end
