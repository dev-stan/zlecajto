# frozen_string_literal: true

module Conversations
  class Participants
    def initialize(conversation)
      @conversation = conversation
    end

    # Returns an array of both participants
    def all
      [conversation.submission_owner, conversation.task_owner].freeze
    end

    # Checks if a given user is part of this conversation
    def include?(user)
      return false unless user

      all.map(&:id).include?(user.id)
    end

    # Returns the other participant in the conversation
    def other(user)
      return unless include?(user)

      (all - [user]).first
    end

    private

    attr_reader :conversation
  end
end
