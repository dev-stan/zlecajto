# frozen_string_literal: true

module Messages
  module Emailable
    extend ActiveSupport::Concern
    include Rails.application.routes.url_helpers

    def send_new_message_email
      MailgunTemplateJob.perform_later(
        to: conversation.other_participant(user).email,
        template: 'chat_notification_new_message',
        subject: "Nowa wiadomość - #{conversation.task.title}",
        variables: {
          author_first_name: user.first_name.capitalize,
          author_last_name: user.last_name.capitalize, 
          task_title: conversation.task.title,
          message_content: content,
          conversation_url: Rails.application.routes.url_helpers.conversation_url(conversation)
        }
      )
    end
  end
end
