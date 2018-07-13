class User < ApplicationRecord
  has_many :follow_users, dependent: :destroy
  has_many :follow_courses, dependent: :destroy
  has_many :lession_logs, dependent: :destroy
  has_many :question_logs, through: :lession_logs, dependent: :destroy

  before_save :downcase_email
  USER_ATTRS = %w(name email password password_confirmation).freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true,
    length: {maximum: Settings.user.length.max_name}
  validates :email, presence: true,
    length: {maximum: Settings.user.length.max_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user.length.min_pass}, allow_nil: true

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
