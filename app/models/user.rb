# frozen_string_literal: true

class User < ApplicationRecord
  # Ensure superpowers is always an array
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
  validates :phone_number, presence: true
  validates :superpowers,
            length: { maximum: 3,
                      message: I18n.t('errors.messages.superpowers_limit',
                                      default: 'Możesz wybrać maksymalnie 3 supermoce.') }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
