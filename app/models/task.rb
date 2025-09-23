# frozen_string_literal: true

class Task < ApplicationRecord
  STATUSES        = ['draft', 'Otwarte', 'W trakcie', 'Zakończone', 'Anulowane'].freeze
  CATEGORIES      = %w[Sprzątanie Zakupy Montaż Transport Przeprowadzki Opieka
                       Naprawy Ogrodnictwo].freeze

  TIMESLOTS       = %w[Rano Popołudnie Wieczór Obojętnie].freeze
  PAYMENT_METHODS = %w[Przelew Blik Gotówka].freeze
  LOCATIONS       = ['Stary Strzeszyn', 'Osiedle Literackie', 'Strzeszyn Grecki', 'Osiedle Wojskowe'].freeze

  belongs_to :user
  has_many :submissions, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :photos

  validates :status, inclusion: { in: STATUSES }, allow_blank: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true
  validates :timeslot, inclusion: { in: TIMESLOTS }, allow_blank: true
  validates :location, inclusion: { in: LOCATIONS }, allow_blank: true

  before_validation :set_default_status

  after_create :send_task_created_email

  private

  def set_default_status
    self.status ||= 'Otwarte'
  end

  def send_task_created_email
    MailgunTemplateJob.perform_later(to: email, template: 'welcome_email', subject: 'Witaj w zlecajto :)',
                                     variables: { test: 'test' })
  end
end
