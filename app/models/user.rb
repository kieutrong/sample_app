class User < ApplicationRecord
  before_save {email.downcase!}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Setting.email.maximum},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: Setting.username.maximum}
  validates :password, presence: true, length: {minimum: Setting.password.minimum}

  has_secure_password
end
