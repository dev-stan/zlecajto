# frozen_string_literal: true

module Conversations
  class ReadTracker
    def initialize(conversation)
      @conversation = conversation
    end

    def last_seen_column_for(user)
      return unless participant?(user)

      if user.id == conversation.submission_owner_id
        :submission_owner_last_seen_at
      else
        :task_owner_last_seen_at
      end
    end

    def last_seen_at_for(user)
      col = last_seen_column_for(user)
      col && conversation[col]
    end

    def mark_seen_by(user, time = Time.current)
      col = last_seen_column_for(user)
      conversation.update_column(col, time) if col # rubocop:disable Rails/SkipsModelValidations
    end

    def unread_for?(user)
      last_message = conversation.messages.last
      return false unless last_message
      return false if last_message.user_id == user.id # own messages never unread

      last_seen = last_seen_at_for(user)
      last_seen.nil? || last_message.created_at > last_seen
    end

    private

    attr_reader :conversation

    def participant?(user)
      user && (user.id == conversation.submission_owner_id ||
               user.id == conversation.task_owner_id)
    end
  end
end
