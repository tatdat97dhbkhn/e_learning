class ChooseCategoryController < ApplicationController
  skip_before_action :is_admin?

  def choose_category
    @categories = Category.all
    @arr_color = %w(success info warning danger)
    @number_courses = []
    @categories.each do |category|
      @number_courses.push category.courses.count
    end

    @lession_logs = LessionLog.where user_id: current_user.id, pass: true

    pass_courses = []
    Category.all.each do |category|
      category.courses.each do |course|
        if course.lession_logs.count > 0 && course.lession_logs.current(current_user).pass_lession.count != 0
          pass_courses.push Settings.number.one 
        else
          pass_courses.push Settings.number.zero
        end
      end
    end
    
    @status_courses = []
    @i = 0
    @number_courses.each do |number_course|
      @status_courses.push pass_courses[@i...number_course + @i]
      @i += number_course
    end

    @result = []
    @status_courses.each do |status_course|
      res = status_course.count(Settings.number.one).to_f / status_course.count
      @result.push res
    end

    @progress = []
    @progress.push @categories
    @progress.push @result
    
  end
end
