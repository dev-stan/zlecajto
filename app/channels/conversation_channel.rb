# frozen_string_literal: true

class ConversationChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find(params[:conversation_id])

    # Authorize: only participants can subscribe
    unless [@conversation.sender_id, @conversation.recipient_id].include?(current_user.id)
      Rails.logger.warn "[Cable] #{current_user.id} tried to subscribe to conversation=#{@conversation.id} but is not a participant. REJECTED."
      reject
      return
    end

    # IMPORTANT: Stream a personalized stream per participant so we can
    # broadcast pre-rendered, user-specific HTML from Message.after_create_commit
    # (which calls: ConversationChannel.broadcast_to([conversation, participant], ...))
    stream_key = ConversationChannel.broadcasting_for([@conversation, current_user])
    Rails.logger.info "[Cable] #{current_user.id} subscribed to Conversation stream=#{stream_key}"
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
