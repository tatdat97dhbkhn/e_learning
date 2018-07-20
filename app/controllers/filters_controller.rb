class FiltersController < ApplicationController
  before_action :logged_in_user,
    only: %i(listword listwordcategory listwordalphabet listword_learned)

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
    @lession_logs_count = @lession_logs.all.group(:lession_id).count

    @lession_logs_last = []
    unless @lession_logs_count.empty?
      @lession_logs_count.each do |lle|
        @lession_logs_last.push LessionLog.where(lession_id: lle[0]).last
      end
    end

    @question_logs = []
    @lession_logs_last.each do |lll|
      @question_logs.push QuestionLog.where lession_log_id: lll.id
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
