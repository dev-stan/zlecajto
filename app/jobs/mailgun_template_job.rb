# frozen_string_literal: true

class MailgunTemplateJob < ApplicationJob
  queue_as :default

  def perform(to:, template:, subject:, variables: {}, from: nil)
    api_key = Rails.application.credentials.dig(:mailgun, :api_key)
    domain  = Rails.application.credentials.dig(:mailgun, :domain)
    client  = Mailgun::Client.new(api_key, 'api.eu.mailgun.net')

    from_email = from || ApplicationMailer.default_params[:from] || "no-reply@#{domain}"

    client.send_message(
      domain,
      {
        from: from_email,
        to: to,
        subject: subject,
        template: template,
        'h:X-Mailgun-Variables': (variables || {}).to_json
      }
    )
  end
end
