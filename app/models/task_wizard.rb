# frozen_string_literal: true

class TaskWizard
  STEPS = I18n.t('models.task_wizard.steps').freeze
  PERMITTED_PARAMS = %i[
    category title description salary due_date due_date_any timeslot payment_method location
  ].freeze

  attr_reader :current_step, :params_hash

  def self.build_from_params(params)
    new(step: params[:step], params: params[:task])
  end

  def initialize(step: 1, params: {})
    @current_step = normalize_step(step)
    @params_hash = clean_params(params)
  end

  # Build unsaved Task
  def task
    @task ||= Task.new(params_hash.except(:due_date_any))
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

  def advance!
    @current_step = next_step_number
  end

  def step_partial
    "tasks/steps/#{current_step}"
  end

  def params_for_step
    params_hash.slice(*PERMITTED_PARAMS)
  end

  private

  def clean_params(raw_params)
    raw_params ||= {}
    raw_params = raw_params.to_unsafe_h if raw_params.respond_to?(:to_unsafe_h)
    cleaned = raw_params.transform_keys(&:to_sym).slice(*PERMITTED_PARAMS)
    cleaned.delete(:due_date) if cleaned[:due_date_any].present?
    cleaned
  end

  def normalize_step(step)
    step = step.to_i
    return 1 if step < 1
    return total_steps if step > total_steps

    step
  rescue StandardError
    1
  end
end
