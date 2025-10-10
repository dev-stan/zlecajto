# frozen_string_literal: true

class TaskMessage < ApplicationRecord
  belongs_to :task
  belongs_to :user
  belongs_to :parent, class_name: 'TaskMessage', optional: true
  has_many :replies, class_name: 'TaskMessage', foreign_key: :parent_id, dependent: :destroy

  validates :body, presence: true, length: { maximum: 2000 }

  enum message_type: { question: 0, reply: 1 }

  scope :root, -> { where(parent_id: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def root?
    parent_id.nil?
  end

  # Returns the top-most message in the thread
  def thread_root
    parent ? parent.thread_root : self
  end
end
