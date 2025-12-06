class Review < ApplicationRecord
  belongs_to :task

  belongs_to :author,    class_name: "User"
  belongs_to :recipient, class_name: "User"

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :description, length: { maximum: 2000 }, allow_blank: true

  validates :author_id, uniqueness: { scope: [:task_id, :recipient_id] }
end
