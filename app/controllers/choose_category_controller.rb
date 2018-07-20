class ChooseCategoryController < ApplicationController
  def choose_category
    @categories = Category.all
  end
end
