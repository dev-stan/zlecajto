# frozen_string_literal: true

class Submission < ApplicationRecord
  include Submissions::Emailable
  include Submissions::Notifiable

  belongs_to :task
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :notifications, as: :notifiable

  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :task_id, message: 'has already applied to this task' }
  validate :cannot_apply_to_own_task

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  after_create :send_new_submission_email
  after_create :create_new_submission_notification

  def accept!
    return if accepted?

    transaction do
      update!(status: :accepted)
      task.update!(status: :accepted)
      send_accepted_submission_email
      create_accepted_submission_notification
    end
  end

  private

  def cannot_apply_to_own_task
    return unless task.user_id == user_id

    errors.add(:base, 'Nie możesz zgłosić się do własnego zadania')
  end
end
