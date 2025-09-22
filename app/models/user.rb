# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  after_create :send_welcome_email

  has_one_attached :profile_picture
  has_many :tasks
  has_many :submissions

  validates :first_name, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true, unless: :google_oauth_user?

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end

  def google_oauth_user?
    provider.present? && uid.present?
  end

  def self.from_google(auth)
    # Try to find by provider + uid or email
    user = find_by(provider: auth.provider, uid: auth.uid)
    user ||= find_by(email: auth.info.email)

    # If still not found, create a new user
    if user
      user.update(provider: auth.provider, uid: auth.uid) if user.provider.blank? || user.uid.blank?
    else
      user = create(
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        first_name: auth.info.first_name,
        last_name: auth.info.last_name,
        provider: auth.provider,
        uid: auth.uid
      )
      if auth.info.image.present?
        user.profile_picture.attach(
          io: URI.open(auth.info.image),
          filename: 'profile.jpg'
        )
      end
    end

    user
  end
end
