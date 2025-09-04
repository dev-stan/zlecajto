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
  SUPERPOWERS = %w[TEST1 TEST2 TEST3 TEST4 TEST5].freeze

  has_one_attached :profile_picture

  validates :superpowers,
            length: { maximum: 3,
                      message: I18n.t('errors.messages.superpowers_limit',
                                      default: 'Możesz wybrać maksymalnie 3 supermoce.') }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_roles
  has_many :roles, through: :user_roles
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
