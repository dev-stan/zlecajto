# frozen_string_literal: true

module Conversations
  class StatusChecker
    def initialize(conversation)
      @conversation = conversation
    end

    def status
      accepted_submission = conversation.task.accepted_submission
      participant_submission = conversation.submission_for(conversation.submission_owner)

      return :cancelled if conversation.task.cancelled?
      return :wrong_submission unless accepted_submission == participant_submission

      :active
    rescue StandardError
      :wrong_submission
    end

    private

    attr_reader :conversation
  end
end
