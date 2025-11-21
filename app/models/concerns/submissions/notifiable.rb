# frozen_string_literal: true

module Submissions
  module Notifiable
    extend ActiveSupport::Concern

    def create_new_submission_notification
      Notifications::NewSubmission.new(self).call
    end

    def create_accepted_submission_notification
      Notifications::SubmissionAccepted.new(self).call
    end
  end
end
