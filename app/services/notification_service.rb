# frozen_string_literal: true

class NotificationService
  # [todo] Change naming of those methods
  def self.notify_new_submission(submission)
    # This creates a notification for the user who owns the task
    Notification.create!(
      user: submission.task.user,
      subject: 'new_submission',
      notifiable: submission
    )
  end

  def self.notify_accepted_submission(submission)
    # This creates a notification for the user who made the submission
    Notification.create!(
      user: submission.user,
      subject: 'accepted_submission',
      notifiable: submission
    )
  end
end
