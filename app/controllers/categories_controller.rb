class CategoriesController < ApplicationController
  before_action :find_category, only: %i(edit update destroy)

  def new
    @category = Category.new
  end

  def index
    @categories = get_using_category true
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
    flash[:warning] = category.destroy_actions params[:do]
    redirect_back fallback_location: root_path
  end

  def restore
    @categories = get_using_category false
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

  def get_using_category flag
    Category.using(flag).page(params[:page]).per_page Settings.data.pages
  end
end
