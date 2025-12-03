# frozen_string_literal: true

module Conversations
  module MessageForm
    class MessageFormComponent < ViewComponent::Base
      def initialize(conversation:, current_user:, status:)
        super()
        @conversation = conversation
        @current_user = current_user
        @status = status
      end

      private

      attr_reader :conversation, :current_user

      # Presenter methods for view concerns
      def btn_primary
        'rounded-xl flex items-center justify-center size-12 bg-primary text-white hover:bg-blue-600'
      end

      def icon_base
        'fa-solid text-white text-xl'
      end

      def input_classes
        'flex-1 rounded-full border-2 border-blue-400 pl-3 py-3 text-base bg-white focus:outline-none focus:border-blue-600'
      end
    end
  end
end
