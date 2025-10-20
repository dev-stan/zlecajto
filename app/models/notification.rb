# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true

  scope :unread, -> { where(read_at: nil) }

  # Returns notifications whose notifiable is a Submission belonging to the given task
  scope :for_task, lambda { |task|
    next none unless task

    where(notifiable_type: 'Submission', notifiable_id: task.submissions.select(:id))
  }

  def seen?
    read_at.present?
  end

  def mark_as_read!
    update!(read_at: Time.current) if read_at.nil?
  end

  # Ransack allowlist for ActiveAdmin
  def self.ransackable_attributes(_auth_object = nil)
    %w[id user_id subject read_at notifiable_type notifiable_id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user notifiable]
  end
end
