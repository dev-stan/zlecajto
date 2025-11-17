# frozen_string_literal: true

module Submissions
  module Smsable
    extend ActiveSupport::Concern
    include Rails.application.routes.url_helpers

    private

    def send_new_submission_sms
      External::Sms::SmsSender.send_now(
        to: task.user.phone_number,
        body: I18n.t('models.submission.sms.new_submission', name: user.first_name, title: task.title, note: note,
                                                             url: task_url(task.id))
      )
    end
  end
end
