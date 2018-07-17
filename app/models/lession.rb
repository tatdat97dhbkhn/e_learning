class Lession < ApplicationRecord
  belongs_to :course
  has_many :lession_logs, dependent: :destroy

  LESSION_ATTRS = %w(name description course_id image).freeze
  mount_uploader :image, ImagesUploader

  validates :name, presence: true,
    length: {maximum: Settings.lession.length.max_name},
    uniqueness: {case_sensitive: false}
  validates :course_id,
    presence: {message: I18n.t("not_blank")}
  validate  :image_size

  class << self
    def get_name_by_lession_logs lession_logs
      @lessions = []

      lession_logs.each do |lession_log|
        @lessions.push lession_log.lession.name
      end
      @lessions
    end
  end

  private

  def image_size
    return unless image.size > Settings.image.capacity.megabytes
    errors.add :picture, t("less")
  end
end
