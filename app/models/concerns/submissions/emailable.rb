# frozen_string_literal: true

module Submissions
  module Emailable
    extend ActiveSupport::Concern
    include Rails.application.routes.url_helpers

    private

    def send_accepted_submission_email
      MailgunTemplateJob.perform_later(
        to: user.email,
        template: 'prod_submission_accepted',
        subject: 'Twoje zgłoszenie zostało zaakceptowane!',
        variables: {
          due_date: task.due_date.strftime('%d/%m/%Y'),
          location: task.location,
          salary: task.salary,
          timeslot: task.timeslot,
          title: task.title,
          task_url: task_url(task.id)
        }
      )
    end

    def send_new_submission_email
      MailgunTemplateJob.perform_later(
        to: task.user.email,
        template: 'prod_new_submission',
        subject: 'Nowe zgłoszenie!',
        variables: {
          user_name: user.first_name,
          user_note: note,
          my_task_url: my_task_url(task.id),
          task_url: task_url(task.id)
        }
      )
    end
  end
end
