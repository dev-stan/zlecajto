# app/services/messages/broadcast_service.rb
module Messages
  class BroadcastService
    def self.call(message)
      new(message).call
    end

    def initialize(message)
      @message = message
      @conversation = message.conversation
    end

    def call
      @conversation.participants.each do |participant|
        html = render_html_for(participant)
        ConversationChannel.broadcast_to([@conversation, participant], { html: html })
      end
    end

    private

    def render_html_for(user)
      ApplicationController.renderer.render(
        Messages::MessageComponent.new(message: @message, current_user: user),
        layout: false
      )
    end
  end
end
