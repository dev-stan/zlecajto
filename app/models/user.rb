# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  require 'open-uri'

  def self.from_google(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20] # random password
      user.first_name = auth.info.first_name
      user.last_name  = auth.info.last_name
      if auth.info.image.present?
        user.profile_picture.attach(
          io: URI.open(auth.info.image),
          filename: 'profile.jpg'
        )
      end
    end
  end

  def superpowers
    self[:superpowers] || []
  end

  def superpowers=(values)
    self[:superpowers] = Array(values).reject(&:blank?).uniq.take(3)
  end
  # SUPERPOWERS constant for user selection
  SUPERPOWERS = [
    'Nocny Marek',
    'Ranny Ptaszek',
    'Cichy Specjalista',
    'Architekt Porządku',
    'Kreatywny Chaos',
    'Mistrz Gaduła',
    'Stara Szkoła',
    'Kawowy Wojownik',
    'Student na Urlopie',
    'Mistrz Prokrastynacji',
    'Zjadacz Deadlineów',
    'Wieczny Optymista',
    'Szef Kanapek',
    'Kreator Awarii',
    'Szybki Scrollowicz',
    'Kolekcjoner Zakładek',
    'Władca Przekąsek',
    'Ekspert Odkładania',
    'Mistrz Znikania',
    'Pogromca Bugów',
    'Szef Small Talku',
    'Koneser Memów'
  ]

  has_one_attached :profile_picture

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true, unless: :google_oauth_user?

  def google_oauth_user?
    provider.present? && uid.present?
  end
  validates :superpowers,
            length: { maximum: 3,
                      message: I18n.t('errors.messages.superpowers_limit',
                                      default: 'Możesz wybrać maksymalnie 3 supermoce.') }

  has_many :tasks
  has_many :submissions
  has_many :reviews, through: :tasks

  def has_role?(role_name)
    roles.exists?(name: role_name)
  end

  def has_unseen_accepted_submissions?
    latest = submissions.accepted.maximum(:updated_at)
    return false unless latest

    last_seen = last_seen_accepted_submission_at
    last_seen.nil? || latest > last_seen
  end

  def mark_accepted_submissions_seen!
    update_column(:last_seen_accepted_submission_at, Time.current)
  end
end
