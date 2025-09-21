# frozen_string_literal: true

class Submission < ApplicationRecord
  # Associations
  belongs_to :task
  belongs_to :user

  # Validations
  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :task_id, message: 'has already applied to this task' }

  # Constants
  STATUSES = %w[pending accepted rejected].freeze

  validates :status, inclusion: { in: STATUSES }

  # Scopes
  scope :pending, -> { where(status: 'pending') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :rejected, -> { where(status: 'rejected') }

  # Default status
  after_initialize :set_default_status, if: :new_record?

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
