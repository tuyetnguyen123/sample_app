class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true,
    length: {maximum: Settings.user_valid.max_length_name}
  validates :email, presence: true,
    length: {maximum: Settings.user_valid.max_length_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user_valid.min_length_password}

  has_secure_password
  before_save :email_downcase

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               eBCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def email_downcase
    email.downcase!
  end
end
