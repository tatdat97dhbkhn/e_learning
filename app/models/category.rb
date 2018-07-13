class Category < ApplicationRecord
  has_many :courses, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :lessions, through: :courses, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.category.length.max_name}
end
