# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :profile_picture
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
