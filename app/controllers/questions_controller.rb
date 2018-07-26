class QuestionsController < ApplicationController
  before_action :find_question, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all.page(params[:page]).per_page Settings.data.pages
  end

  def new
    @question = Question.new
    @answer = Answer.new
  end

  def create
    @question = Question.new question_params
    if @question.save
      flash[:success] = t ".success"
      redirect_to request.referrer
    else
      flash[:danger] = t "danger"
      render :new
    end
  end

  def edit; end

  def destroy
    if @question.destroy
      flash[:success] = t ".delete"
      redirect_to questions_url
    else
      flash[:danger] = t "danger"
      redirect_to home_path
    end
  end

  def update
    if @question.update_attributes question_params
      flash[:success] = t ".success"
      redirect_to questions_path
    else
      flash[:danger] = t "danger"
      redirect_to root_path
    end
  end

  private

  attr_reader :question

  def question_params
    params.require(:question).permit Question::QUESTION_ATTRS
  end

  def find_question
    @question = Question.find_by id: params[:id]
    return if @question
    redirect_to root_path
  end
end
