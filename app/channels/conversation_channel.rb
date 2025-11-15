# frozen_string_literal: true

class ConversationChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find(params[:conversation_id])

    Rails.logger.info "🔥 SUBSCRIBED to conversation=#{@conversation.id} as current_user=#{current_user.id}"

    # Authorize: only participants can subscribe
    unless [@conversation.sender_id, @conversation.recipient_id].include?(current_user.id)
      reject
    end

    stream_for [@conversation, current_user]
  end

  def receive(data)
    message = @conversation.messages.build(
      content: data['content'],
      user: current_user
    )

    Array.wrap(data['attachments']).each do |signed_id|
      message.photos.attach(signed_id)
    end

    message.save!
  end
end
