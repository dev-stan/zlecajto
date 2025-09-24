# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :task_id, message: 'has already applied to this task' }
  validate :cannot_apply_to_own_task

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  # Ensure a default status is set before validations run.
  after_initialize :set_default_status, if: :new_record?

  after_create :send_new_submission_email

  def accept!
    update!(status: :accepted)
  end

  private

  def set_default_status
    self.status ||= :pending
  end

  def cannot_apply_to_own_task
    return unless task && user
    if task.user_id == user_id
      errors.add(:base, 'Nie możesz zgłosić się do własnego zadania')
    end
  end

  def send_new_submission_email
    # [TODO] Implement email notification to task owner about new submission
  end
end
