class QuestionLogsController < ApplicationController
  def update
    question_log = QuestionLog.find_by id: params[:id]
    question_log.update_result
  end
end
