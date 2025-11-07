# frozen_string_literal: true

class ConversationChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find(params[:conversation_id])
    stream_for @conversation
  end

  def receive(data)
    @conversation.messages.create!(
      content: data['content'],
      user: current_user
    )
  end
end
