# frozen_string_literal: true

class ConversationChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find(params[:conversation_id])

    # Authorize: only participants can subscribe
    unless [@conversation.sender_id, @conversation.recipient_id].include?(current_user.id)
      reject
    end

    stream_for [@conversation, current_user]
  end

  def unsubscribed
    Rails.logger.info "[Cable] #{current_user.id} unsubscribed"
  end

  def receive(data)
    @conversation.messages.create!(
      content: data['content'],
      user: current_user
    )
  end
end
