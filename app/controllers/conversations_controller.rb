class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.includes(:user).order(:created_at)
  end

  def create
    @conversation = Conversation.between(current_user.id, params[:recipient_id]).first_or_create!(
      sender_id: current_user.id,
      recipient_id: params[:recipient_id]
    )

    redirect_to @conversation
  end
end
