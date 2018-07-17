class CategoriesController < ApplicationController
  before_action :find_category, only: %i(edit update destroy)

  def new
    @category = Category.new
  end

  def index
    @categories = Category.all.page(params[:page]).per_page Settings.data.pages
  end

  def edit; end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t ".success"
      redirect_to request.referrer
    else
      flash[:danger] = t "danger"
      render :new
    end
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t ".success"
      redirect_to categories_path
    else
      flash[:danger] = t "danger"
      redirect_to root_path
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t ".delete"
      redirect_to categories_url
    else
      flash[:danger] = t "danger"
      redirect_to home_path
    end
  end

  private

  attr_reader :category

  def category_params
    params.require(:category).permit Category::CATEGORY_ATTRS
  end

  def find_category
    @category = Category.find_by id: params[:id]
    return if @category
    redirect_to root_path
  end
end
