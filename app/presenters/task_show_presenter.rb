# frozen_string_literal: true

class TaskShowPresenter
  include Rails.application.routes.url_helpers

  attr_reader :task, :current_user

  def initialize(task, current_user)
    @task = task
    @current_user = current_user
  end

  def button_text
    return t('button_text.cancelled') if task.cancelled?
    return t('button_text.overdue') if task.overdue?
    return t('button_text.completed') if task.completed?
    return t('button_text.owner') if owner?
    return t('button_text.you_were_chosen') if current_user_accepted_submission?
    return t('button_text.executor_chosen') if accepted_submission_exists?
    return t('button_text.already_applied') if user_has_applied?

    t('button_text.apply')
  end

  def button_variant
    return :red if task.cancelled?
    return :red    if task.overdue?
    return :green  if task.completed?
    return :primary if owner?
    return :green  if current_user_accepted_submission?
    return :red    if accepted_submission_exists?
    return :primary if user_has_applied?

    :primary
  end

  def button_path
    return my_task_path(task) if owner?
    return '#' if completed_submission_for_current_user?
    return conversation_path(accepted_submission.conversation) if current_user_accepted_submission?
    return '#' if accepted_submission_exists?
    return '#' if user_has_applied?
    return '#' if task.overdue? || task.cancelled?

    new_task_submission_path(task)
  end

  def submissions_header
    return t('submissions_header.completed') if task.completed?
    return t('submissions_header.overdue') if task.overdue?

    return unless accepted_submission
    return t('submissions_header.chosen_owner') if owner?
    return t('submissions_header.chosen_for_you') if accepted_submission.user == current_user

    t('submissions_header.chosen_executor') if task.submissions.accepted.exists?
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

  def t(key, **opts)
    I18n.t("presenters.task_show_presenter.#{key}", **opts)
  end

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
