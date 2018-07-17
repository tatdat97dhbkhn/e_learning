class LessonLogsController < ApplicationController
  before_action :logged_in_user, only: :show
  before_action :find_lesson_log, only: %i(show update)
  skip_before_action :is_admin?

  def create
    @lesson_log = LessonLog.create user_id: current_user[:id],
      lesson_id: params[:id]
    lesson_log.create_lesson_log
    redirect_to lesson_log
  end

  def show
    lesson_log.update_attributes spend_time: @lesson_log.updated_at
    redirect_to root_path unless current_user
    @question_logs = lesson_log.question_logs
    @questions, @answers = LessonLog.get_lesson_log @question_logs
    return if lesson_log.pass.nil?
    @corrects = Answer.get_correct_answers @answers
  end

  def update
    lesson_log.update_attributes spend_time: lesson_log.updated_at.to_i
    @question_logs = if params[:questionlog]
                       params[:questionlog]
                     else
                       Settings.number.zero
                     end
    lesson_log.update_result @question_logs, params[:commit]
    redirect_to profile_path
  end

  private

  attr_reader :lesson_log

  def find_lesson_log
    @lesson_log = LessonLog.find_by id: params[:id]
    return if lesson_log
    flash[:danger] = t ".danger"
    redirect_to root_path
  end
end
