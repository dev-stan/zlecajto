# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user # the sender

  # Simple MVP: allow attaching multiple photos to a message
  has_many_attached :photos

  after_create_commit :broadcast_message

  private

  def broadcast_message
    [conversation.sender, conversation.recipient].each do |participant|
      html = ApplicationController.renderer.render(
        Messages::MessageComponent.new(message: self, current_user: participant),
        layout: false
      )

      ConversationChannel.broadcast_to([conversation, participant], { html: html })
    end
  end
end
