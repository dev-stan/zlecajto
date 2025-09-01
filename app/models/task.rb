# frozen_string_literal: true

class Task < ApplicationRecord
  STATUSES        = %w[draft open in_progress completed cancelled].freeze
  CATEGORIES      = %w[Sprzątanie Zakupy Montaż Transport Przeprowadzki Opieka
                       Naprawianie Ogrodnictwo].freeze

  TIMESLOTS       = %w[Rano Popołudnie Wieczór].freeze
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

  private

  def set_default_status
    self.status ||= 'draft'
  end
end
