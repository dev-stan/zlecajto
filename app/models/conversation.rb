# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :submission_owner, class_name: 'User'
  belongs_to :task_owner, class_name: 'User'
  belongs_to :task
  belongs_to :submission

  has_many :messages, dependent: :destroy

  scope :between, lambda { |user1_id, user2_id|
    where(submission_owner_id: user1_id, task_owner_id: user2_id)
      .or(where(submission_owner_id: user2_id, task_owner_id: user1_id))
  }

  scope :for_user, lambda { |user|
    where('submission_owner_id = :id OR task_owner_id = :id', id: user.id)
  }

  def participants_service
    @participants_service ||= Conversations::Participants.new(self)
  end

  def read_tracker
    @read_tracker ||= Conversations::ReadTracker.new(self)
  end

  def status_checker
    @status_checker ||= Conversations::StatusChecker.new(self)
  end

  delegate :participants, :participant?, :other_participant, to: :participants_service
  delegate :unread_for?, :mark_seen_by, :last_seen_at_for, :last_seen_column_for, to: :read_tracker
  delegate :status, to: :status_checker

  def submission_for(user)
    task.submissions.find_by(user_id: user.id)
  end
end
