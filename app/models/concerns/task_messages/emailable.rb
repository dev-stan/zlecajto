# frozen_string_literal: true

module TaskMessages
  module Emailable
    extend ActiveSupport::Concern

    private

    # [todo] specify which task this is about / link task
    def send_new_question_email
      MailgunTemplateJob.perform_later(
        to: replying_to_user.email,
        template: 'prod_new_question',
        subject: 'Nowe pytanie do Twojego zlecenia',
        variables: { user_first_name: user.first_name, question_body: body }
      )
    end

    def send_new_reply_email
      MailgunTemplateJob.perform_later(
        to: replying_to_user.email,
        template: 'prod_new_reply',
        subject: 'Nowa odpowiedź w wątku!',
        variables: { user_first_name: user.first_name, reply_body: body }
      )
    end
  end
end
