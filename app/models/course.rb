class Course < ApplicationRecord
  belongs_to :category
  has_many :follow_courses, dependent: :destroy
  has_many :lessions, dependent: :destroy
  has_many :lession_logs, through: :lessions

  COURSE_ATTRS = %w(name description category_id image).freeze
  mount_uploader :image, ImagesUploader

  validates :name, presence: true,
    length: {maximum: Settings.course.length.max_name},
    uniqueness: {case_sensitive: false}
  validates :category_id,
    presence: {message: I18n.t("not_blank")}
  validate  :image_size

  private

  def image_size
    return unless image.size > Settings.image.capacity.megabytes
    errors.add :picture, t("less")
  end
end
