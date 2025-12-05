# frozen_string_literal: true

class Message < ApplicationRecord
  include Messages::Emailable
  belongs_to :conversation
  belongs_to :user
  after_create_commit :send_new_message_email

  has_many_attached :photos

  after_create_commit -> { Messages::BroadcastService.call(self) }

  def read_by?(user)
    return true if user_id == user.id

    seen_at = conversation.last_seen_at_for(user)
    seen_at.present? && created_at <= seen_at
  end
end
