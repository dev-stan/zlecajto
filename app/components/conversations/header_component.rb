# frozen_string_literal: true

module Conversations
  class HeaderComponent < ViewComponent::Base
    def initialize(conversation:, current_user:)
      super()
      @conversation = conversation
      @current_user = current_user
    end

    private

    attr_reader :conversation, :current_user

    def other_participant
      conversation.other_participant(current_user)
    end

    def task
      conversation.task
    end

    def task_status
      # Assuming @status is derived from task or conversation
      case conversation.task.status
      when 'active' then :active
      when 'cancelled' then :cancelled
      when 'wrong_submission' then :wrong_submission
      else :unknown
      end
    end

    def status_color
      task_status == :active ? 'text-green-600' : 'text-red-600'
    end

    def formatted_task_salary
      # You can move formatted_salary helper here or keep as helper
      ApplicationController.helpers.formatted_salary(task)
    end
  end
end
