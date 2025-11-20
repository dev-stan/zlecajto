# frozen_string_literal: true

class TaskWizard
  STEPS = I18n.t('models.task_wizard.steps').freeze
  PERMITTED_PARAMS = %i[
    category title description salary due_date due_date_any timeslot payment_method location
  ].freeze

  attr_reader :current_step, :params_hash

  def initialize(step: 1, params: {}, advance: false)
    @current_step = normalize_step(step)
    @params_hash = process_params(params)
    advance_step if advance
  end

  # Step helpers
  def total_steps
    STEPS.size
  end

  def last_step?
    current_step == total_steps
  end

  def next_step_number
    [current_step + 1, total_steps].min
  end

  def advance_step
    @current_step = next_step_number
  end

  def labels
    STEPS
  end

  # Build unsaved Task from wizard params
  def task
    @task ||= Task.new(params_hash.except(:due_date_any))
  end

  private

  # Clean and normalize incoming params
  def process_params(raw_params)
    raw_params = raw_params.to_unsafe_h if raw_params.respond_to?(:to_unsafe_h)
    raw_params ||= {}

    clean = raw_params.transform_keys(&:to_sym).slice(*PERMITTED_PARAMS)
    clean.delete(:due_date) if clean[:due_date_any].present?
    clean
  end

  # Ensure step is within valid range
  def normalize_step(step)
    step = step.to_i
    return 1 if step < 1
    return total_steps if step > total_steps

    step
  rescue StandardError
    1
  end
end
