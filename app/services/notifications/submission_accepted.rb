# frozen_string_literal: true

module Notifications
  class SubmissionAccepted
    def initialize(submission)
      @submission = submission
    end

    def call
      Notification.create!(
        user: @submission.user,
        subject: 'accepted_submission',
        notifiable: @submission
      )
    end
  end
end
