# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user # the sender

  validates :content, presence: true, length: { maximum: 2000 }

  after_create_commit -> { ConversationChannel.broadcast_to(conversation, MessageSerializer.new(self).as_json) }
end
