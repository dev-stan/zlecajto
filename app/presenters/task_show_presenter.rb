# frozen_string_literal: true

class TaskShowPresenter
  include Rails.application.routes.url_helpers

  attr_reader :task, :current_user

  def initialize(task, current_user)
    @task = task
    @current_user = current_user
  end

  def button_text
    return 'Anulowano zlecenie' if task.cancelled?
    return 'Upłynął termin' if task.overdue?
    return 'Zlecenie zakończone' if task.completed?
    return 'Wybrano cię! Co dalej?' if current_user_accepted_submission?
    return 'Wybrano już wykonawcę' if accepted_submission_exists?
    return 'Już aplikowałeś' if user_has_applied?
    return 'Zobacz detale zlecenia' if owner?

    'Aplikuj'
  end

  def button_variant
    case button_text
    when 'Anulowano zlecenie' then :red
    when 'Upłynął termin' then :red
    when 'Zobacz detale zlecenia' then :primary
    when 'Zlecenie zakończone' then :green
    when 'Wybrano cię! Co dalej?' then :green
    when 'Wybrano już wykonawcę' then :red
    when 'Już aplikowałeś' then :primary
    when 'Aplikuj' then :primary
    end
  end

  def button_path
    return contact_submission_path(task.submissions.accepted.first) if owner? && accepted_submission_exists?
    return my_task_path(task) if owner?
    return '#' if completed_submission_for_current_user?
    return accepted_submission_path(current_user_accepted_submission) if current_user_accepted_submission?
    return '#' if accepted_submission_exists?
    return '#' if user_has_applied?

    new_task_submission_path(task)
  end

  def submissions_header
    return 'Zlecenie wykonane!' if task.completed?
    return 'Upłynął termin zlecenia' if task.overdue?

    return unless accepted_submission
    return 'Wybrałeś wykonawcę!' if owner?
    return 'Wybrał Cię zleceniodawca! Skontaktuj się z nim.' if accepted_submission.user == current_user

    'Wybrany wykonawca' if task.submissions.accepted.exists?
  end

  # Owner or the submission owner can either reply or (owner only) accept
  def can_reply_or_accept?(submission)
    (can_reply?(submission) || can_accept?(submission)) && !task.cancelled? && !task.completed? && !task.overdue?
  end

  # Owner may accept a submission only if the task isn't completed and no one is accepted yet
  # and the given submission is not already the accepted one.
  def can_accept?(submission)
    return false unless owner?
    return false if task.completed?
    return false if accepted_submission.present? # someone already accepted

    # guard against accepting the same submission again:
    submission.id != accepted_submission&.id
  end

  # Either owner or the submission author can reply
  def can_reply?(submission)
    owner? || submission.user == current_user
  end

  def owner?
    current_user == task.user
  end

  private

  def user_has_applied?
    current_user_submission.present?
  end

  def current_user_submission
    @current_user_submission ||= current_user&.submissions&.find_by(task: task)
  end

  def accepted_submission_exists?
    task.submissions.accepted.exists?
  end

  def accepted_submission
    @accepted_submission ||= task.submissions.accepted.first
  end

  def current_user_accepted_submission
    @current_user_accepted_submission ||= task.submissions.accepted.find_by(user_id: current_user&.id)
  end

  def current_user_accepted_submission?
    current_user_accepted_submission.present?
  end

  def completed_submission_for_current_user?
    task.completed? && current_user_accepted_submission?
  end
end
