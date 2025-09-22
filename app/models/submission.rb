# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :task_id, message: 'has already applied to this task' }

  STATUSES = %w[pending accepted rejected].freeze

  validates :status, inclusion: { in: STATUSES }

  scope :pending, -> { where(status: 'pending') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :rejected, -> { where(status: 'rejected') }

  after_initialize :set_default_status, if: :new_record?
  after_create :send_new_submission_email

  def send_new_submission_email
    debugger
    UserMailer.new_submission(task.user).deliver_later
  end

  def accepted?
    status == 'accepted'
  end

  def pending?
    status == 'pending'
  end

  private

  def set_default_status
    self.status ||= 'pending'
  end
end
