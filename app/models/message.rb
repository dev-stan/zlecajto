# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user # the sender

  validates :content, presence: true, length: { maximum: 2000 }

  after_create_commit :broadcast_message

  private

  def broadcast_message
    ConversationChannel.broadcast_to(conversation, {
                                       id: id,
                                       user_name: user.display_name,
                                       content: content,
                                       created_at: created_at.strftime('%H:%M')
                                     })
  end
end
