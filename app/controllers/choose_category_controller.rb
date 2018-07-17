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
        if course.lession_logs.current(current_user).pass_lession.count != 0
          pass_courses.push(1)
        else
          pass_courses.push(0)
        end
      end
    end

    @status_courses = []
    @number_courses.each do |number_course|
      @status_courses.push pass_courses[0...number_course]
      (0...number_course).each do |number|
        pass_courses.delete_at(number)
      end
    end

    @result = []
    @status_courses.each do |status_course|
      @result.push status_course.count(1).to_f / status_course.count
    end
  end
end
