
# frozen_string_literal: true

class TaskShowPresenter
  include Rails.application.routes.url_helpers

  attr_reader :task, :current_user

  def initialize(task, current_user)
    @task = task
    @current_user = current_user
  end

  # public api 

  def button_text
    t("button_text.#{button_state}")
  end

  def button_variant
    BUTTON_CONFIG.dig(button_state, :variant) || :primary
  end

  def button_path
    path_handler = BUTTON_CONFIG.dig(button_state, :path) || ->(p) { p.send(:new_task_submission_path, p.task) }
    path_handler.call(self)
  end

  def submissions_header
    return nil unless header_state
    t("submissions_header.#{header_state}")
  end

  def can_reply_or_accept?(submission)
    task_is_active? && (can_reply?(submission) || can_accept?(submission))
  end

  def can_accept?(submission)
    owner? && task_is_active? && !accepted_submission.present?
  end

  def can_reply?(submission)
    return false unless current_user

    owner? || submission.user == current_user
  end

  def owner?
    current_user == task.user
  end

  private
  
  # button config

  BUTTON_CONFIG = {
    cancelled: {
      variant: :red,
      path: ->(_) { '#' }
    },
    overdue: {
      variant: :red,
      path: ->(_) { '#' }
    },
    leave_review: {
      variant: :green,
      path: ->(p) { p.send(:new_review_path, task_id: p.task.id) }
    },
    completed: {
      variant: :green,
      path: ->(_) { '#' }
    },
    owner: {
      variant: :primary,
      path: ->(p) { p.send(:my_task_path, p.task) }
    },
    you_were_chosen: {
      variant: :green,
      path: ->(p) { 
        conversation = p.send(:accepted_submission)&.conversation
        conversation ? p.send(:conversation_path, conversation) : '#'
      }
    },
    executor_chosen: {
      variant: :red,
      path: ->(_) { '#' }
    },
    already_applied: {
      variant: :primary,
      path: ->(_) { '#' }
    }
  }.freeze

  # state determination

  def button_state
    @button_state ||= begin
      return :cancelled if task.cancelled?
      return :overdue if task.overdue?
      return :leave_review if needs_review?
      return :completed if task.completed?
      return :owner if owner?
      return :you_were_chosen if current_user_accepted_submission?
      return :executor_chosen if accepted_submission_exists?
      return :already_applied if user_has_applied?
      
      :apply
    end
  end

  def header_state
    @header_state ||= begin
      return :completed if task.completed?
      return :overdue if task.overdue?
      return nil unless accepted_submission_exists?

      return :chosen_owner if owner?
      return :chosen_for_you if current_user && accepted_submission.user == current_user
      
      :chosen_executor
    end
  end

  # ========== Helpers ==========

  def task_is_active?
    !task.cancelled? && !task.completed? && !task.overdue?
  end

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
    accepted_submission.present?
  end

  def accepted_submission
    @accepted_submission ||= task.submissions.accepted.first
  end

  def current_user_accepted_submission?
    return false unless current_user

    accepted_submission&.user == current_user
  end

  def needs_review?
    return false unless task.completed?
    return false unless current_user.present?
    return false unless participated_in_task?
    
    !current_user_has_reviewed?
  end

  def participated_in_task?
    owner? || current_user_accepted_submission?
  end

  def current_user_has_reviewed?
    current_user.authored_reviews.exists?(task: task)
  end
end