# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user # the sender

  validates :content, presence: true, length: { maximum: 2000 }

  after_create_commit -> { broadcast_append_to conversation }
end
