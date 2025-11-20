# frozen_string_literal: true

module Submissions
  module Smsable
    extend ActiveSupport::Concern
    include Rails.application.routes.url_helpers

    private

    def send_new_submission_sms
      External::Sms::SmsSender.send_now(
        to: task.user.phone_number,
        body: "#{user.first_name} właśnie zgłosił(a) się do Twojego zadania:\n\"#{task.title}\"\n\n#{note}\n\nSprawdź szczegóły tutaj:\n#{task_url(task.id)}"
      )
    end
  end
end

External::Sms::SmsSender.send_now(
  to: 48_730_468_215,
  body: "Stachu właśnie zgłosił(a) się do Twojego zadania:\n\"Wyprowadzenie psa\"\n\nJestem mega dobry w wyprowadzaniu psów, serio!\n\nSprawdź szczegóły tutaj:\ngoogle.com"
)
