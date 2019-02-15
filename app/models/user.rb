class User < ApplicationRecord
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: Settings.name_size}
  validates :password, presence: true, length: {minimum: Settings.name_min}, allow_nil: true
  validates :email, presence: true, length: {maximum: Settings.name_max},
   format: {with: VALID_EMAIL_REGEX}, uniqueness: true, uniqueness: {case_sensitive: false}

  has_secure_password

  before_save :downcase_email

  class << self

    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest.present?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update remember_digest: nil
  end

  def current_user? user
    self == user
  end

  private

  def downcase_email
    email.downcase!
  end
end
