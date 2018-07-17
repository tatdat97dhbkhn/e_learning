class LessionLogsController < ApplicationController
  def index
    redirect_to root_path if current_user? current_user
  end

  def show
    redirect_to root_path unless current_user
    @lession_log = LessionLog.find_by id: params[:id]
    @question_logs = @lession_log.question_logs

    @questions, @answers = LessionLog.get_lession_log @question_logs
  end

  def create
    @lession_log = LessionLog.create user_id: current_user[:id],
      lession_id: params[:id]
    @lession_log.create_lession_log
    redirect_to @lession_log
  end

  def update
    @lession_log = LessionLog.find_by id: params[:id]
    @question_logs = params[:questionlog]

    @lession_log.update_result @question_logs
    redirect_to "#"
  end
end
