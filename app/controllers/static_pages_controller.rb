class StaticPagesController < ApplicationController
  skip_before_action :is_admin?

  def home
    @categories = Category.includes(:courses).select :id, :name, :description
    return unless logged_in?
    @courses = Course.includes(:lessons).select :id, :name
    @lesson_logs = LessonLog.get_lessons_user(current_user).
      paginate page: params[:page], per_page: Settings.data.pages
    @results = LessonLog.get_results @lesson_logs
  end
end
