# frozen_string_literal: true

module Submissions
  class CancellChosenService
    def initialize(submission)
      @submission = submission
      @task = submission.task
    end

    def call
      @submission.transaction do
        @task.submissions.each { |sub| sub.update!(status: :pending) }
        @task.update!(status: :open)
      end
    end
  end
end
