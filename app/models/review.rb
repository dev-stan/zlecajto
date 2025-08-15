# frozen_string_literal: true

class Review < ApplicationRecord
  # Associations
  belongs_to :task
  has_one :user, through: :task

  # Validations
  validates :title, presence: true
  validates :description, presence: true
end
