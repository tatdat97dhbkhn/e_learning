class CoursesController < ApplicationController
  before_action :find_course, only: [:edit, :update, :destroy]

  def index
    @courses = Course.paginate page: params[:page],
      per_page: Settings.data.pages
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new course_params
    if @course.save
      flash[:success] = t ".success"
      redirect_to request.referrer
    else
      flash[:danger] = t "danger"
      render :new
    end
  end

  def edit; end

  def destroy
    if @course.destroy
      flash[:success] = t ".delete"
      redirect_to courses_url
    else
      flash[:danger] = t "danger"
      redirect_to home_path
    end
  end

  private

  attr_reader :course

  def course_params
    params.require(:course).permit Course::COURSE_ATTRS
  end

  def find_course
    @course = Course.find_by id: params[:id]
    return if @course
    redirect_to root_path
  end
end
