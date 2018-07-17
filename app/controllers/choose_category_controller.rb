class ChooseCategoryController < ApplicationController
  skip_before_action :is_admin?
  
  def choose_category
    @categories = Category.all
  end
end
