# frozen_string_literal: true

module Submissions
  class AcceptService
    def initialize(submission)
      @submission = submission
      @task = submission.task
    end

    def call
      return if @submission.accepted?

      @submission.transaction do
        @submission.update!(status: :accepted)
        @task.update!(status: :accepted)

        @submission.send_accepted_submission_email
        @submission.create_accepted_submission_notification
      end
    end
  end
end
