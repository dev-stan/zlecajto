# frozen_string_literal: true

class Task < ApplicationRecord
  include Tasks::Emailable
  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_many :notifications, as: :notifiable
  has_many_attached :photos
  has_many :task_messages, dependent: :destroy
  has_many :conversations # should ideally have one - has more if submission.user changes

  has_one :accepted_submission, -> { where(status: :accepted) }, class_name: 'Submission'

  enum status: {
    open: 'open',
    cancelled: 'cancelled',
    accepted: 'accepted',
    completed: 'completed',
    overdue: 'overdue'
  }

  scope :with_submissions, -> { includes(:submissions) }

  CATEGORIES       = %w[Zwierzaki Naprawy Ogród Transport Korki Eventy Przeprowadzki Sprzątanie Rower Inne].freeze
  TIMESLOTS        = %w[Rano Popołudnie Wieczór Obojętnie].freeze
  PAYMENT_METHODS  = %w[Przelew Blik Gotówka Czekolada].freeze
  LOCATIONS        = ['Stary Strzeszyn', 'Osiedle Literackie', 'Strzeszyn Grecki', 'Osiedle Wojskowe',
                      'Jelonek', 'Suchy Las Wschód', 'Suchy Las Zachód', 'Złotniki', 'Zlecenie zdalne'].freeze

  validates :title, presence: true
  validates :category, inclusion: { in: CATEGORIES }
  validates :timeslot, inclusion: { in: TIMESLOTS }
  validates :location, inclusion: { in: LOCATIONS }

  # Ransack allowlist for ActiveAdmin
  def self.ransackable_attributes(_auth_object = nil)
    %w[id title description salary status user_id category due_date location payment_method timeslot created_at
       updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user submissions task_messages notifications]
  end
end
