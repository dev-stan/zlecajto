# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  has_many_attached :photos

  after_create_commit :broadcast_message

  def read_by?(user)
    return true if user_id == user.id

    seen_at = conversation.last_seen_at_for(user)
    seen_at.present? && created_at <= seen_at
  end

  private

  def broadcast_message
    [conversation.task_owner, conversation.submission_owner].each do |participant|
      html = ApplicationController.renderer.render(
        Messages::MessageComponent.new(message: self, current_user: participant),
        layout: false
      )

      ConversationChannel.broadcast_to([conversation, participant], { html: html })
    end
  end
end
