# frozen_string_literal: true

module Messages
  class MessageComponent < ViewComponent::Base
    def initialize(message:, current_user:)
      @message = message
      @current_user = current_user
    end

    private

    attr_reader :message, :current_user

    def current_user_message?
      message.user == current_user
    end

    def message_classes
      base = 'flex flex-col p-4 rounded-2xl max-w-xs break-words'
      base += current_user_message? ? ' bg-blue-100 text-gray-800 self-end' : ' bg-gray-100 text-gray-800 self-start'
      base
    end
  end
end
