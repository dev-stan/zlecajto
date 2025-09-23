# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :task_id, message: 'has already applied to this task' }

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  after_create :send_new_submission_email

  def accept!
    update!(status: :accepted)
  end

  private

  def send_new_submission_email
    # [TODO] Implement email notification to task owner about new submission
  end
end
