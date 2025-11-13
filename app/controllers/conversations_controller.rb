class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]
  before_action :ensure_participant!, only: [:show]

  def show
    @hide_navbar = true
    @messages = @conversation.messages.includes(:user).order(:created_at)
  end

  def create
    @conversation = Conversation.between(current_user.id, params[:recipient_id]).first_or_create!(
      sender_id: current_user.id,
      recipient_id: params[:recipient_id]
    )

    redirect_to @conversation
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def ensure_participant!
    unless @conversation.participant?(current_user)
      redirect_to root_path, alert: 'Nie masz dostępu do tej rozmowy.' and return
    end
  end
end
