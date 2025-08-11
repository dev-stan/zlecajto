class Task < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :applications, dependent: :destroy
  has_many :reviews, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :salary, numericality: true, allow_nil: true
  validates :status, presence: true, inclusion: { in: %w[draft open in_progress completed cancelled], message: ": invalid status" }
end
