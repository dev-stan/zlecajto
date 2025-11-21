# frozen_string_literal: true

module Tasks
  module Emailable
    extend ActiveSupport::Concern

    def send_completed_task_email
      MailgunTemplateJob.perform_later(
        to: user.email,
        template: 'zakonczenie_zadania_zleceniodawca_fixed',
        subject: I18n.t('models.task.email_subjects.completed_for_owner'),
        variables: { task_title: title }
      )
    end

    def send_completed_submission_email
      accepted_submission = submissions.accepted.first
      return unless accepted_submission

      MailgunTemplateJob.perform_later(
        to: accepted_submission.user.email,
        template: 'zakonczenie_zadania_do_wykonawcy_fixed',
        subject: I18n.t('models.task.email_subjects.completed_for_executor'),
        variables: { task_title: title }
      )
    end
  end
end
