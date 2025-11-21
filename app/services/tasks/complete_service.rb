# frozen_string_literal: true

module Tasks
  class CompleteService
    def initialize(task)
      @task = task
    end

    def call
      return if @task.completed?

      @task.transaction do
        @task.update!(status: :completed)
        send_emails
      end
    end

    private

    def send_emails
      @task.send_completed_task_email
      @task.send_completed_submission_email
    end
  end
end
