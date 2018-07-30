class Category < ApplicationRecord
  has_many :courses, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :lessons, through: :courses, dependent: :destroy
  has_many :answers, through: :questions, dependent: :destroy

  CATEGORY_ATTRS = %w(name description).freeze

  scope :created, ->{where created_at: :desc}

  validates :name, presence: true,
    length: {maximum: Settings.category.length.max_name},
    uniqueness: {case_sensitive: false}
  validates :description,
    length: {maximum: Settings.category.length.max_des}

  def destroy_actions act
    if act.eql? I18n.t("delete")
      do_destroy 
    else
      update_attributes used: !used
      I18n.t("warning")
    end
  end

  def do_destroy
    if valid_to_destroy
      destroy
      return I18n.t("success")
    end
    I18n.t("danger")
  end

  private

  def valid_to_destroy
    lessons.each do |l|
      return if l.lesson_logs
    end
    true
  end
end
