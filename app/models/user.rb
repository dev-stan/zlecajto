# frozen_string_literal: true

class User < ApplicationRecord
  include GoogleAuthenticatable
  include FacebookAuthenticatable

  has_many :tasks
  has_many :submissions
  has_many :answers
  has_many :notifications
  has_many :conversations_as_sender, class_name: 'Conversation', foreign_key: 'sender_id', dependent: :destroy
  has_many :conversations_as_recipient, class_name: 'Conversation', foreign_key: 'recipient_id', dependent: :destroy

  has_one_attached :profile_picture

  validates :first_name, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true, unless: :google_oauth_user?

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :trackable, omniauth_providers: %i[google_oauth2 facebook]

  after_create :send_welcome_email

  def unread_notifications_count = notifications.unread.count
  def unread_notifications_for_task?(task) = notifications.unread.for_task(task).exists?
  def remember_me = true

  # def phone_number
  #   return if super.blank?

  #   number = super.to_s.strip.gsub(/\D/, '') # remove all non-digit chars

  #   # Add +48 if it doesn't already have a country code
  #   number.start_with?('48') ? "+#{number}" : "+48#{number.sub(/^0/, '')}"
  # end
  #

  def display_name
    "#{first_name} #{last_name.first.upcase if last_name.present?}"
  end

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

  def self.ransackable_attributes(auth_object = nil)
    %w[address admin category created_at current_sign_in_at current_sign_in_ip email
       encrypted_password first_name id id_value last_name last_seen_accepted_submission_at last_sign_in_at last_sign_in_ip phone_number provider remember_created_at reset_password_sent_at reset_password_token role sign_in_count superpowers uid updated_at verified]
  end
end
