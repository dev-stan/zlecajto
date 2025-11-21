# frozen_string_literal: true

module Notifications
  class NewSubmission
    def initialize(submission)
      @submission = submission
    end

    def call
      Notification.create!(
        user: @submission.task.user,
        subject: 'new_submission',
        notifiable: @submission
      )
    end
  end
end
