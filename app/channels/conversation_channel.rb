# frozen_string_literal: true

class ConversationChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find(params[:conversation_id])

    # Authorize: only participants can subscribe
    unless [@conversation.task_owner.id, @conversation.submission_owner_id].include?(current_user.id)
      reject
    end

    stream_for [@conversation, current_user]
  rescue => e
    reject
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
