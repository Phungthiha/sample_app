class User < ApplicationRecord
  before_save :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  has_secure_password
  validates :name, presence: true, length: {maximum: Settings.name_size}
  validates :email, presence: true, length: {maximum: Settings.name_max},
   format: { with: VALID_EMAIL_REGEX }, uniqueness: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: {minimum: Settings.name_min}

  private

  def downcase_email
    email.downcase!
  end
end
