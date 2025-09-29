# frozen_string_literal: true

class Submission < ApplicationRecord

  belongs_to :task
  belongs_to :user

  has_many :notifications, as: :notifiable

  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :task_id, message: 'has already applied to this task' }
  validate :cannot_apply_to_own_task

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  after_initialize :set_default_status, if: :new_record?
  after_create :send_new_submission_email
  after_create :create_new_submission_notification

  def accept!
    transaction do
      update!(status: :accepted)
      create_accepted_submission_notification
    end
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
    MailgunTemplateJob.perform_later(to: task.user.email, template: 'nowa_oferta_new', subject: 'Nowa oferta!',
                                     variables: { salary: task.salary, title: task.title, timeslot: task.timeslot, location: task.location, due_date: task.due_date, first_name: task.user.first_name})
  end

  def create_new_submission_notification
    NotificationService.notify_new_submission(self)
  end

  def create_accepted_submission_notification
    NotificationService.notify_accepted_submission(self)
  end
end
