# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :submission
  after_create :send_new_answer_email
  validates :message, presence: true, length: { maximum: 1000 }

  # Ransack allowlist for ActiveAdmin
  def self.ransackable_attributes(_auth_object = nil)
    %w[id user_id submission_id message created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user submission]
  end

  private

  def send_new_answer_email
    recipient_user = user == submission.user ? submission.task.user : submission.user

    MailgunTemplateJob.perform_later(to: recipient_user.email, template: 'prod_new_answer', subject: I18n.t('models.answer.email_subjects.new_answer'),
                                     variables: { first_name: recipient_user.first_name, answer_message: message })
  end
end
