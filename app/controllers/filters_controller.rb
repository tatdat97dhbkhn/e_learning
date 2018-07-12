class FiltersController < ApplicationController
  def listword
    @answers = Answer.where correct: Settings.number.one
  end

  def listwordcategory
    @category = Category.find_by id: params[:id]
    @answers = @category.answers.where correct: Settings.number.one
  end

  def listwordalphabet
    @answers = Answer.where(correct: Settings.number.one).order "content ASC"
  end

  def listwordleanred
  end
end
