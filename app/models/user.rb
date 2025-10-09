# frozen_string_literal: true

class User < ApplicationRecord
  include GoogleAuthenticatable

  has_many :tasks
  has_many :submissions
  has_many :answers
  has_many :notifications
  has_one_attached :profile_picture

  validates :first_name, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true, unless: :google_oauth_user?

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :trackable, omniauth_providers: [:google_oauth2]

  after_create :send_welcome_email

  def unread_notifications_count = notifications.unread.count
  def unread_notifications_for_task?(task) = notifications.unread.for_task(task).exists?
  def remember_me = true

  private

  def send_welcome_email
    MailgunTemplateJob.perform_later(
      to: email,
      template: 'prod_welcome_email',
      subject: 'Witaj w zlecajto :)'
    )
  end

  def google_oauth_user?
    provider.present? && uid.present?
  end
end
