class LessionsController < ApplicationController
  before_action :find_lession, only: [:edit, :update, :destroy]
  def new
    @lession = Lession.new
  end

  def create
    @lession = Lession.new lession_params
    if @lession.save
      flash[:success] = t ".success"
      redirect_to request.referrer
    else
      flash[:danger] = t "danger"
      render :new
    end
  end

  def edit; end

  def index
    @lessions = Lession.all.page(params[:page]).per_page Settings.data.pages
  end

  def destroy
    if @lession.destroy
      flash[:success] = t ".delete"
      redirect_to lessions_url
    else
      flash[:danger] = t "danger"
      redirect_to home_path
    end
  end

  private

  attr_reader :lession

  def lession_params
    params.require(:lession).permit Lession::LESSION_ATTRS
  end

  def find_lession
    @lession = Lession.find_by id: params[:id]
    return if @lession
    redirect_to root_path
  end
end
