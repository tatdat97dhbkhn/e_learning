class User < ApplicationRecord
  attr_accessor :remember_token

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

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine.cost
            end
      BCrypt::Password.create string, cost: cost
    end
  end

  def downcase_email
    email.downcase!
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end
end
