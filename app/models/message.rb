# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user # the sender

  has_many_attached :photos

  after_create_commit :broadcast_message

  def read_by?(user)
    return true if user_id == user.id

    seen_at = conversation.last_seen_at_for(user)
    seen_at.present? && created_at <= seen_at
  end

  private

  def broadcast_message
    [conversation.sender, conversation.recipient].each do |participant|
      html = ApplicationController.renderer.render(
        # Use self (the current Message instance). `message` local was undefined and prevented rendering.
        Messages::MessageComponent.new(message: self, current_user: participant),
        layout: false
      )

      ConversationChannel.broadcast_to([conversation, participant], { html: html })
    end
  end
end
