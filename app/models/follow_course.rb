class FollowCourse < ApplicationRecord
  belongs_to :user
  belongs_to :course

  def find_follows
    @follow_courses = course.follow_courses.where(user_id: current_user.id)
  end
end
