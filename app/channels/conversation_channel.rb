# frozen_string_literal: true

require 'base64'
require 'stringio'

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
    images = Array.wrap(data['images']).compact
    content = data['content'].presence || (images.present? ? '[image]' : '')

    # For MVP purposes, we accept base64 data URLs sent from the client and attach them
    message = @conversation.messages.build(
      content: content,
      user: current_user
    )

    if images.present?
      images.each_with_index do |data_url, idx|
        if (match = data_url.match(/^data:(.*?);base64,(.*)$/))
          content_type = match[1]
          base64_data = match[2]
          io = StringIO.new(Base64.decode64(base64_data))
          filename_ext = Rack::Mime::MIME_TYPES.invert[content_type] || '.png'
          filename_ext = ".#{filename_ext.delete_prefix('.')}" unless filename_ext.start_with?('.')
          filename = "conversation-image-#{Time.now.to_i}-#{idx}#{filename_ext}"
          message.photos.attach(io: io, filename: filename, content_type: content_type)
        end
      rescue StandardError => e
        Rails.logger.error("[Cable] Failed to attach inline image: #{e.class} - #{e.message}")
      end
    end

    message.save!
  end
end
