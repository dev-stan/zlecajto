# frozen_string_literal: true

module Submissions
  module Notifiable
    extend ActiveSupport::Concern

    private

    def create_new_submission_notification
      NotificationService.notify_new_submission(self)
    end

    def create_accepted_submission_notification
      NotificationService.notify_accepted_submission(self)
    end
  end
end
