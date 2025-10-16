# frozen_string_literal: true

class TaskMessage < ApplicationRecord
  belongs_to :task
  belongs_to :user
  belongs_to :parent, class_name: 'TaskMessage', optional: true
  has_many :replies, class_name: 'TaskMessage', foreign_key: :parent_id, dependent: :destroy

  after_create :send_new_question_email, if: :question?
  after_create :send_new_reply_email, if: :reply?

  include TaskMessages::Emailable

  validates :body, presence: true, length: { maximum: 200 }

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

  # Depth-first ordered list of all messages in this thread (root first)
  def thread_messages_flat
    root = thread_root
    list = [root]
    root.send(:accumulate_descendants_in_order, list)
    list
  end

  # Returns the newest message in the current thread (by created_at)
  def thread_latest_message
    thread_messages_flat.max_by(&:created_at)
  end

  # Returns the User that this message is effectively replying to.
  # Walks up the parent chain and finds the first ancestor whose author
  # is different from the current message's author. Returns task.user if none.
  def replying_to_user
    return task.user if parent.blank?

    author = user
    node = parent
    node = node.parent while node && node.user == author

    return node.user if node

    # No different author found in the chain; prefer thread root user if different,
    # otherwise fall back to the task owner
    root_user = thread_root.user
    return root_user if root_user && root_user != author

    task.user
  end

  private

  # Recursively appends descendants in created_at ascending order
  def accumulate_descendants_in_order(list)
    replies.order(created_at: :asc).each do |child|
      list << child
      child.send(:accumulate_descendants_in_order, list)
    end
  end
end
