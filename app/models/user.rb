class User < ApplicationRecord
  require "securerandom"

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  def self.find_or_create_from_auth_hash auth
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |u|
      u.provider = auth.provider
      u.uid = auth.uid
      u.oauth_token = auth.credentials.token
      u.oauth_expires_at = Time.at auth.credentials.expires_at
      u.name = auth.info.name
      u.email = auth.info.email
      u.avatar = URI.parse auth.info.image
      u.password = SecureRandom.urlsafe_base64
      u.save!
    end
  end



  has_many :follow_users, dependent: :destroy
  has_many :follow_courses, dependent: :destroy
  has_many :lesson_logs, dependent: :destroy
  has_many :question_logs, through: :lesson_logs, dependent: :destroy

  USER_ATTRS = %w(name email password password_confirmation).freeze
  USER_PARAMS = %w(password password_confirmation).freeze
  USER_ATTRS_EDIT = %w(avatar name email password
    password_confirmation).freeze
  VALID_EMAIL_REGEX = /\A[a-z][a-z0-9_\.]{5,32}@[a-z0-9]{3,}(\.[a-z0-9]{2,4}){1,2}\Z/i

  validates :name, presence: true,
    length: {maximum: Settings.user.length.max_name}
  validates :email, presence: true,
    length: {maximum: Settings.user.length.max_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user.length.min_pass}, allow_nil: true
  validate  :picture_size

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
  mount_uploader :avatar, AvatarUploader

  def picture_size
    return unless avatar.size > Settings.image.capacity.megabytes
    errors.add(:picture, t("image_size"))
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated?(attribute, token)
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def following? follower
    follow_users.find_follow(follower).count > Settings.number.zero
  end

  def follow_status user
    follow_users.find_or_initialize_by follower: user.id
  end

  def get_followers
    User.where id: get_follower_ids
  end

  def get_unfollowers
    User.where.not id: get_follower_ids.push(id)
  end

  def activate
    update_attributes activated: true, activated_at: Time.zone.now
  end
  
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    time = Settings.time.hours
    reset_sent_at < time.hours.ago
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest activation_token
  end

  def get_follower_ids
    follower_ids = []

    follow_users.each do |follower|
      follower_ids.push follower.follower
    end
    follower_ids
  end
end
