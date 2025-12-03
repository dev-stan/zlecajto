# frozen_string_literal: true

class ConversationChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "ActionCable: Subscribing to ConversationChannel with params: #{params.inspect}"
    @conversation = Conversation.find(params[:conversation_id])

    # Authorize: only participants can subscribe
    unless [@conversation.task_owner.id, @conversation.submission_owner_id].include?(current_user.id)
      Rails.logger.warn "ActionCable: User #{current_user.id} unauthorized for Conversation #{@conversation.id}"
      reject
    end

    stream_for [@conversation, current_user]
    Rails.logger.info "User #{current_user.id} subscribed to Conversation #{@conversation.id} channel"
  rescue => e
    Rails.logger.error "ActionCable: Error in subscribed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
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
