# frozen_string_literal: true

class ConversationChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find(params[:conversation_id])
    stream_for @conversation
  end

  def receive(data)
    Rails.logger.info ">>> Received data from client: #{data.inspect}"
    @conversation.messages.create!(
      content: data['content'],
      user: current_user
    )
  end
end
