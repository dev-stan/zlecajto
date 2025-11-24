# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]
  before_action :ensure_participant!, only: [:show]
  before_action :set_conversation_status, only: [:show]

  def index
    @hide_navbar = true
    @conversations = Conversation
                     .for_user(current_user)
                     .includes(:task, :submission_owner, :task_owner)
                     .order(updated_at: :desc)
  end

  def show
    @hide_navbar = true
    @conversation.mark_seen_by(current_user)
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def ensure_participant!
    return if @conversation.participant?(current_user)

    redirect_to root_path, alert: 'Nie masz dostępu do tej rozmowy.'
  end

  def set_conversation_status
    accepted_submission = @conversation.task.accepted_submission
    participant_submission = @conversation.submission_for(@conversation.submission_owner)

    @status = @conversation.status(accepted_submission, participant_submission)
    @status = :wrong_submission
  end
end
