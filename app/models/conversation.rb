# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  belongs_to :task

  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :recipient_id }

  scope :between, lambda { |sender_id, recipient_id|
    where(sender_id:, recipient_id:).or(where(sender_id: recipient_id, recipient_id: sender_id))
  }

  def participant?(user)
    return false if user.nil?

    user.id == sender_id || user.id == recipient_id
  end
end
