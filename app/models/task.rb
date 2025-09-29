# frozen_string_literal: true

class Task < ApplicationRecord

  belongs_to :user

  has_many :submissions, dependent: :destroy
  has_many :notifications, as: :notifiable
  has_many_attached :photos

  before_validation :set_default_status
  after_create :send_task_created_email


  # [todo] Can i make this cleaner with enum?
  STATUSES        = ['draft', 'Otwarte', 'W trakcie', 'Zakończone', 'Anulowane'].freeze
  CATEGORIES      = %w[Sprzątanie Zakupy Montaż Transport Przeprowadzki Opieka
                       Naprawy Ogrodnictwo].freeze

  TIMESLOTS       = %w[Rano Popołudnie Wieczór Obojętnie].freeze
  PAYMENT_METHODS = %w[Przelew Blik Gotówka].freeze
  LOCATIONS       = ['Stary Strzeszyn', 'Osiedle Literackie', 'Strzeszyn Grecki', 'Osiedle Wojskowe'].freeze

  validates :status, inclusion: { in: STATUSES }, allow_blank: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true
  validates :timeslot, inclusion: { in: TIMESLOTS }, allow_blank: true
  validates :location, inclusion: { in: LOCATIONS }, allow_blank: true

  private

  def set_default_status
    self.status ||= 'Otwarte'
  end

  def send_task_created_email
    # MailgunTemplateJob.perform_later(to: user.email, template: 'welcome_email', subject: 'Witaj w zlecajto :)',
    #                                  variables: { test: 'test' })
  end
end
