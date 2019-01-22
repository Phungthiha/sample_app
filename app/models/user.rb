class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: Settings.name_size}
  validates :email, presence: true, length: {maximum: Settings.name_max},
   format: {with: VALID_EMAIL_REGEX}, uniqueness: true, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.name_min}
  has_secure_password
  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
