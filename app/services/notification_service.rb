class NotificationService
  def self.notify_new_submission(submission)

    # This creates a notification for the user who owns the task
    Notification.create!(
      user: submission.task.user,
      subject: "new_submission",
      notifiable: submission
    )
  end
end