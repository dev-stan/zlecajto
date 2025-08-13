class Task < ApplicationRecord
  STATUSES   = %w[draft open in_progress completed cancelled].freeze
  CATEGORIES = %w[Design Development Writing Other].freeze

  belongs_to :user
  has_many :applications, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :title, :description, :category, :user, presence: true
  validates :status, inclusion: { in: STATUSES }, allow_blank: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true

  before_validation :set_default_status

  private

  def set_default_status
    self.status ||= 'draft'
  end
end
