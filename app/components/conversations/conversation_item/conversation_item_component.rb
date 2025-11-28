# frozen_string_literal: true

module Conversations
  module ConversationItem
    class ConversationItemComponent < ViewComponent::Base
      def initialize(conversation:, current_user:)
        super()
        @conversation = conversation
        @current_user = current_user
      end

      private

      attr_reader :conversation, :current_user

      def other_user
        conversation.other_participant(current_user)
      end

      def last_message
        @last_message ||= conversation.messages.last
      end

      def unread?
        conversation.unread_for?(current_user)
      end

      def status_text
        I18n.t("conversations.statuses.#{conversation.status}", default: I18n.t('conversations.statuses.unknown'))
      end

      def status_class
        {
          active: 'text-green-600',
          cancelled: 'text-red-600',
          wrong_submission: 'text-red-600',
          completed: 'text-green-600'
        }[conversation.status] || 'text-gray-600'
      end

      def message_preview
        last_message&.content.presence || I18n.t('components.conversations.conversation_item.sent_photo')
      end

      def reading_icon_class
        unread? ? 'text-gray-400' : 'text-green-500'
      end
    end
  end
end
