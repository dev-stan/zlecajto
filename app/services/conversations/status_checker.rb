# frozen_string_literal: true

module Conversations
  class StatusChecker
    def initialize(conversation)
      @conversation = conversation
    end

    def status(accepted_submission, participant_submission)
      return :cancelled if conversation.task.cancelled?
      return :wrong_submission unless accepted_submission == participant_submission

      :active
    end

    private

    attr_reader :conversation
  end
end
