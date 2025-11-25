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
        {
          active: 'Zaakceptowano',
          cancelled: 'Anulowano',
          wrong_submission: 'Zmieniono wykonawcę'
        }[@status] || 'Status nieznany'
      end

      def status_color
        @status == :active ? 'text-green-600' : 'text-red-600'
      end

      def formatted_task_salary
        # You can move formatted_salary helper here or keep as helper
        ApplicationController.helpers.formatted_salary(task)
      end
    end
  end
end
