# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user # the sender

  validates :content, presence: true, length: { maximum: 2000 }

  after_create_commit :broadcast_message

  private

  def broadcast_message
    # Broadcast personalized, pre-rendered HTML to each participant stream
    [conversation.sender, conversation.recipient].each do |participant|
      html = ApplicationController.renderer.render(
        Messages::MessageComponent.new(message: self, current_user: participant),
        layout: false
      )

      stream_key = ConversationChannel.broadcasting_for([conversation, participant])
      Rails.logger.info "[Cable] Broadcasting message ##{id} to stream=#{stream_key} for participant_id=#{participant.id}"
      ConversationChannel.broadcast_to([conversation, participant], { html: html })
    end
  end
end
