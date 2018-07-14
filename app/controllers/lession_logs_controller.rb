class LessionLogsController < ApplicationController
  def index
    redirect_to root_path if current_user? current_user
  end

  def show
    redirect_to root_path unless current_user
    @lessionlog = LessionLog.find_by id: params[:id]
    @questionlogs = @lessionlog.question_logs

    @questions, @answers = LessionLog.get_lessionlog @questionlogs
  end

  def create
    @lessionlog = LessionLog.create user_id: current_user[:id],
      lession_id: params[:id]
    @lessionlog.create_lessionlog
    redirect_to @lessionlog
  end
end
