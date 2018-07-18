class Category < ApplicationRecord
  has_many :courses, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :lessions, through: :courses, dependent: :destroy
  has_many :answers, through: :questions, dependent: :destroy

  CATEGORY_ATTRS = %w(name description).freeze

  scope :created, ->{where created_at: :desc}
  validates :name, presence: true,
    length: {maximum: Settings.category.length.max_name},
    uniqueness: {case_sensitive: false}
end
