class Application < ApplicationRecord
  # Associations
  belongs_to :task
  belongs_to :user

  # Validations
  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :task_id, message: "has already applied to this task" }
end
