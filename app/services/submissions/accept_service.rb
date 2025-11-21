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
        create_conversation

        @submission.send_accepted_submission_email
        @submission.create_accepted_submission_notification
      end
    end

    def create_conversation
      Conversation.create!(submission_owner_id: @submission.user.id, task_owner_id: @submission.task.user.id,
                           task: @submission.task)
    end
  end
end
