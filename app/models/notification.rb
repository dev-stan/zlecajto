class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true
  
  scope :unread, -> { where(read_at: nil) }

  # Returns notifications whose notifiable is a Submission belonging to the given task
  scope :for_task, lambda { |task|
    next none unless task
    where(notifiable_type: 'Submission', notifiable_id: task.submissions.select(:id))
  }


  def seen?
    read_at.present?
  end
  
  def mark_as_read!
    update!(read_at: Time.current) if read_at.nil?
  end
end