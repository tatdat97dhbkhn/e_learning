class Lesson < ApplicationRecord
  belongs_to :course
  has_many :lesson_logs, dependent: :destroy

  LESSON_ATTRS = %w(name description course_id image).freeze
  mount_uploader :image, ImagesUploader

  validates :name, presence: true,
    length: {maximum: Settings.lesson.length.max_name},
    uniqueness: {case_sensitive: false}
  validates :course_id,
    presence: {message: I18n.t("not_blank")}
  validate  :image_size

  class << self
    def get_name_by_lesson_logs lesson_logs
      @lessons = []

      lesson_logs.each do |lesson_log|
        @lessons.push lesson_log.lesson.name
      end
      @lessons
    end
  end

  private

  def image_size
    return unless image.size > Settings.image.capacity.megabytes
    errors.add :picture, t("less")
  end
end
