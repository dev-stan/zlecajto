# frozen_string_literal: true

class Task < ApplicationRecord
  include Tasks::Emailable
  belongs_to :user

  has_many :submissions, dependent: :destroy
  has_many :notifications, as: :notifiable
  has_many_attached :photos
  has_many :task_messages, dependent: :destroy

  enum status: {
    draft: 'draft',
    open: 'Otwarte',
    in_progress: 'W trakcie',
    finished: 'Zakończone',
    cancelled: 'Anulowane',
    accepted: 'accepted',
    completed: 'completed'
  }

  CATEGORIES       = %w[Zwierzaki Naprawy Ogród Transport Korki Eventy Przeprowadzki Sprzątanie Rower Inne].freeze
  TIMESLOTS        = %w[Rano Popołudnie Wieczór Obojętnie].freeze
  PAYMENT_METHODS  = %w[Przelew Blik Gotówka Czekolada].freeze
  LOCATIONS        = ['Stary Strzeszyn', 'Osiedle Literackie', 'Strzeszyn Grecki', 'Osiedle Wojskowe',
                      'Jelonek', 'Suchy Las Wschód', 'Suchy Las Zachód', 'Złotniki'].freeze

  validates :category, inclusion: { in: CATEGORIES }
  validates :timeslot, inclusion: { in: TIMESLOTS }
  validates :location, inclusion: { in: LOCATIONS }

  def complete!
    return if completed?

    transaction do
      update!(status: :completed)
      send_completed_task_email
      send_completed_submission_email
    end
  end
end
