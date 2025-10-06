# frozen_string_literal: true

class Submission < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :task
  belongs_to :user

  has_many :answers, dependent: :destroy
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
      task.update!(status: :accepted)
      send_accepted_submission_email
      create_accepted_submission_notification
    end
  end

  private

  def set_default_status
    self.status ||= :pending
  end

  def cannot_apply_to_own_task
    return unless task && user

    return unless task.user_id == user_id

    errors.add(:base, 'Nie możesz zgłosić się do własnego zadania')
  end

  def send_accepted_submission_email
    MailgunTemplateJob.perform_later(to: user.email, template: 'prod_submission_accepted', subject: 'Twoje zgłoszenie zostało zaakceptowane!',
                                     variables: { due_date: task.due_date.strftime('%d/%m/%Y'), location: task.location, salary: task.salary, timeslot: task.timeslot, title: task.title, task_url: task_url(task.id) })
  end

  def send_new_submission_email
    MailgunTemplateJob.perform_later(to: task.user.email, template: 'prod_new_submission', subject: 'Nowe zgłoszenie!',
                                     variables: { user_name: user.first_name, user_note: note, my_task_url: my_task_url(task.id), task_url: task_url(task.id) })
  end

  def create_new_submission_notification
    NotificationService.notify_new_submission(self)
  end

  def create_accepted_submission_notification
    NotificationService.notify_accepted_submission(self)
  end
end
