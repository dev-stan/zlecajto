# frozen_string_literal: true

module Conversations
  class Participants
    def initialize(conversation)
      @conversation = conversation
    end

    def participants
      [conversation.submission_owner, conversation.task_owner].freeze
    end

    def participant?(user)
      user && participants.map(&:id).include?(user.id)
    end

    def other_participant(user)
      return unless participant?(user)

      (participants - [user]).first
    end

    private

    attr_reader :conversation
  end
end
