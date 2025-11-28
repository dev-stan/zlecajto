# frozen_string_literal: true

module Conversations
  module Header
    class HeaderComponent < ViewComponent::Base
      include ApplicationHelper
      def initialize(conversation:, current_user:, status:)
        super()
        @conversation = conversation
        @current_user = current_user
        @status = status
      end

      private

      attr_reader :conversation, :current_user, :status

      def other_participant
        conversation.other_participant(current_user)
      end

      def task
        conversation.task
      end

      def status_text
        I18n.t("conversations.statuses.#{@status}", default: I18n.t('conversations.statuses.unknown'))
      end

      def status_color
        @status == :active || @status == :completed ? 'text-green-600' : 'text-red-600'
      end

      def formatted_task_salary
        # You can move formatted_salary helper here or keep as helper
        ApplicationController.helpers.formatted_salary(task)
      end
    end
  end
end
