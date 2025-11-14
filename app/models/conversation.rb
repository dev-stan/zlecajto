# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  alias submitter sender
  alias task_owner recipient

  belongs_to :task

  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :recipient_id }

  scope :between, lambda { |sender_id, recipient_id|
    where(sender_id:, recipient_id:).or(where(sender_id: recipient_id, recipient_id: sender_id))
  }

  scope :for_user, ->(user) { where('sender_id = ? OR recipient_id = ?', user.id, user.id) }

  def participant?(user)
    return false if user.nil?

    user.id == sender_id || user.id == recipient_id
  end

  def participants
    [task_owner, submitter]
  end

  def other_participant(user)
    return nil unless participant?(user)

    user.id == task_owner.id ? submitter : task_owner
  end

  def role_for(user)
    return :task_owner if user.id == task_owner.id
    return :submitter if user.id == submitter.id

    nil
  end

  def last_seen_column_for(user)
    return nil unless participant?(user)

    user.id == sender_id ? :sender_last_seen_at : :recipient_last_seen_at
  end

  def last_seen_at_for(user)
    col = last_seen_column_for(user)
    col ? self[col] : nil
  end

  # Mark the conversation as seen by user (defaults to now)
  def mark_seen_by(user, time = Time.current)
    col = last_seen_column_for(user)
    return unless col

    update_column(col, time)
  end

  # Unread if the last incoming message is newer than last_seen
  def unread_for?(user)
    last = messages.last
    return false unless last
    return false if last.user_id == user.id # own messages are never "unread" for author

    seen_at = last_seen_at_for(user)
    seen_at.nil? || last.created_at > seen_at
  end

  # Count unread incoming messages for user
  def unread_count_for(user)
    seen_at = last_seen_at_for(user)
    scope = messages.where.not(user_id: user.id)
    seen_at ? scope.where('created_at > ?', seen_at).count : scope.count
  end
end
