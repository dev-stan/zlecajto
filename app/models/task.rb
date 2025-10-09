# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user

  has_many :submissions, dependent: :destroy
  has_many :notifications, as: :notifiable
  has_many_attached :photos

  before_validation :set_default_status
  after_create :send_task_created_email

  # [todo] Can i make this cleaner with enum?
  STATUSES = ['draft', 'Otwarte', 'W trakcie', 'Zakończone', 'Anulowane', 'accepted', 'completed'].freeze
  CATEGORIES_HOME = {
    'Zwierzaki' => '🐾',
    'Korki' => '📚',
    'Gotowanie' => '🍳',
    'Zakupy' => '🛒',
    'Eventy' => '🎉',
    'Ogród' => '🌿',
    'Rower' => '🚴‍♂️',
    'Komputery' => '💻',
    'Zdjęcia' => '📸',
    'Sprzątanie' => '🧹',
    'Transport' => '🚚',
    'Montaż' => '🛠️',
    'Przeprowadzki' => '📦',
    'Opieka' => '🤝',
    'Naprawy' => '🔧',
    'Inne' => '✨'
  }.freeze

  CATEGORIES = %w[Zwierzaki Naprawy Ogród Transport Korki Eventy Przeprowadzki Sprzątanie Rower Inne].freeze

  TIMESLOTS       = %w[Rano Popołudnie Wieczór Obojętnie].freeze
  PAYMENT_METHODS = %w[Przelew Blik Gotówka Czekolada].freeze
  LOCATIONS       = ['Stary Strzeszyn', 'Osiedle Literackie', 'Strzeszyn Grecki', 'Osiedle Wojskowe',
                     'Jelonek', 'Suchy Las Wschód', 'Suchy Las Zachód', 'Złotniki'].freeze

  validates :status, inclusion: { in: STATUSES }, allow_blank: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true
  validates :timeslot, inclusion: { in: TIMESLOTS }, allow_blank: true
  validates :location, inclusion: { in: LOCATIONS }, allow_blank: true

  # Returns true if the task is completed, false otherwise
  def completed
    %w[completed Zakończone].include?(status.to_s)
  end
  alias completed? completed

  def complete!
    transaction do
      was_completed = completed
      update!(status: 'completed')
      if !was_completed && completed
        send_completed_task_email
        send_completed_submission_email
      end
    end
  end

  private

  def set_default_status
    self.status ||= 'Otwarte'
  end

  # def send_task_created_email
  #   MailgunTemplateJob.perform_later(to: user.email, template: 'welcome_email', subject: 'Witaj w zlecajto :)')
  # end

  def send_completed_task_email
    MailgunTemplateJob.perform_later(to: user.email, template: 'zakonczenie_zadania_zleceniodawca_fixed',
                                     subject: 'Twoje zlecenie zostało zakończone :)', variables: { task_title: title })
  end

  def send_completed_submission_email
    MailgunTemplateJob.perform_later(to: submissions.accepted.first.user.email, template: 'zakonczenie_zadania_do_wykonawcy_fixed',
                                     subject: 'Wykonałeś zadanie!', variables: { task_title: title })
  end
end
