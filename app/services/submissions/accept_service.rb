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
      @submission.with_lock do
        Conversation.create_or_find_by!(
          submission_owner_id: @submission.user_id,
          task_owner_id: @task.user_id,
          task_id: @task.id,
          submission_id: @submission.id
        )
      end
    end
  end
end
