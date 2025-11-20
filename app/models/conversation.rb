# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :submission_owner, class_name: 'User'
  belongs_to :task_owner, class_name: 'User'
  belongs_to :task

  has_many :messages, dependent: :destroy

  # Ensure uniqueness of a conversation between the same two participants
  validates :submission_owner_id, uniqueness: { scope: :task_owner_id }

  # Scopes
  scope :between, lambda { |user1_id, user2_id|
    where(submission_owner_id: user1_id, task_owner_id: user2_id)
      .or(where(submission_owner_id: user2_id, task_owner_id: user1_id))
  }

  scope :for_user, lambda { |user|
    where('submission_owner_id = :id OR task_owner_id = :id', id: user.id)
  }

  # Returns the conversation status based on submissions
  def status(accepted_submission, participant_submission)
    return :cancelled if task.cancelled?
    return :wrong_submission unless accepted_submission == participant_submission

    :active
  end

  def submission_for(user)
    task.submissions.find_by(user_id: user.id)
  end

  # Checks if a user is part of this conversation
  def participant?(user)
    user && (user.id == submission_owner_id || user.id == task_owner_id)
  end

  # Returns both participants
  def participants
    [submission_owner, task_owner].freeze
  end

  # Returns the other participant
  def other_participant(user)
    return unless participant?(user)

    (participants - [user]).first
  end

  # Column for tracking when a user last saw the conversation
  def last_seen_column_for(user)
    return unless participant?(user)

    user.id == submission_owner_id ? :submission_owner_last_seen_at : :task_owner_last_seen_at
  end

  # Timestamp when the user last saw the conversation
  def last_seen_at_for(user)
    col = last_seen_column_for(user)
    col && self[col]
  end

  # Mark the conversation as seen by a user
  def mark_seen_by(user, time = Time.current)
    col = last_seen_column_for(user)
    update_column(col, time) if col
  end

  # Check if the conversation is unread for a user
  def unread_for?(user)
    last_message = messages.last
    return false unless last_message
    return false if last_message.user_id == user.id # Own messages are never unread

    last_seen = last_seen_at_for(user)
    last_seen.nil? || last_message.created_at > last_seen
  end
end
