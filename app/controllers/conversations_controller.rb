# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]
  before_action :ensure_participant!, only: [:show]

  STATUS_PRIORITY = {
    active: 0,
    completed: 1,
    wrong_submission: 2,
    cancelled: 3
  }.freeze

  def index
    @hide_navbar = true
    @conversations = Conversation
                     .for_user(current_user)
                     .includes(:submission_owner, :task_owner, :submission, task: :accepted_submission)
                     .order(updated_at: :desc)
                     .sort_by { |conversation| STATUS_PRIORITY[conversation.status] || 4 }
  end

  def show
    @status = @conversation.status
    @hide_navbar = true
    @conversation.mark_seen_by(current_user)
    mark_accepted_submission_notification_as_read
  end

  private

  def mark_accepted_submission_notification_as_read
    current_user.notifications
                .unread
                .accepted_submission
                .find_by(notifiable: @conversation.submission)
                &.mark_as_read!
  end

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def ensure_participant!
    return if @conversation.participant?(current_user)

    redirect_to root_path, alert: I18n.t('conversations.alerts.access_denied')
  end
end
