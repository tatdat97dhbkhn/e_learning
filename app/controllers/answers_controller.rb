class AnswersController < ApplicationController
  before_action :find_answer, only: [:edit, :update, :destroy]

  def index
    @all_answers = Answer.all.question_id
    @answers = @all_answers.page(params[:page]).per_page Settings.data.pages
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new answer_params
    if @answer.save
      flash[:success] = t ".success"
      redirect_to request.referrer
    else
      flash[:danger] = t "danger"
      render :new
    end
  end

  def edit; end

  def destroy
    if @answer.destroy
      flash[:success] = t ".delete"
      redirect_to answers_url
    else
      flash[:danger] = t "danger"
      render home_path
    end
  end

  private

  attr_reader :answer

  def answer_params
    params.require(:answer).permit Answer::ANSWER_ATTRS
  end

  def find_answer
    @answer = Answer.find_by id: params[:id]
    return if @answer
    redirect_to root_path
  end
end
