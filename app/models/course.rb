class Course < ApplicationRecord
  belongs_to :category
  has_many :follow_courses, dependent: :destroy
  has_many :lessions, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.course.length.max_name}
end
