# frozen_string_literal: true

class Task < ApplicationRecord
  STATUSES   = %w[draft open in_progress completed cancelled].freeze
  CATEGORIES = %w[Sprzątanie Development Writing Other].freeze

  attr_accessor :due_date, :due_time_slot

  belongs_to :user
  has_many :submissions, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :photos

  validates :title, :description, :category, :user, presence: true
  validates :status, inclusion: { in: STATUSES }, allow_blank: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true

  before_validation :set_default_status
  before_validation :compose_due_at

  private

  def set_default_status
    self.status ||= 'draft'
  end

  def compose_due_at
    return if due_at.present? # already set
    return unless due_date.present?

    date = begin
      Date.parse(due_date)
    rescue StandardError
      nil
    end
    return unless date

    hour = case due_time_slot
           when 'rano' then 8
           when 'popoludnie' then 12
           when 'wieczor' then 13
           else 9
           end
    self.due_at = begin
      Time.zone.local(date.year, date.month, date.day, hour, 0, 0)
    rescue StandardError
      nil
    end
  end
end
