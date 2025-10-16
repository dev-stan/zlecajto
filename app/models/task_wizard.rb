# frozen_string_literal: true

class TaskWizard
  STEPS      = ['Tytuł i kategoria', 'Opis', 'Lokalizacja', 'Budżet', 'Zdjęcia'].freeze
  PERMITTED  = %i[category title description salary due_date due_date_any timeslot payment_method location].freeze

  attr_reader :current_step, :params_hash

  def initialize(step:, params:, advance: false)
    @current_step = normalize(step)
    raw = params || {}
    raw = raw.to_unsafe_h if raw.respond_to?(:to_unsafe_h)
    sym = raw.transform_keys(&:to_sym)
    @params_hash = sym.slice(*PERMITTED)
    # If user selected "Obojętnie", drop concrete due_date and transient flag from the task instance
    @params_hash.delete(:due_date) if @params_hash[:due_date_any].present?
    advance_step if advance
  end

  def labels = STEPS
  def total_steps = STEPS.size
  def last_step? = current_step == total_steps
  def next_step_number = [current_step + 1, total_steps].min

  # Unsaved Task built from accumulated params
  def task
    # Don't include the transient due_date_any attribute in the Task model
    build_params = params_hash.except(:due_date_any)
    @task ||= Task.new(build_params)
  end

  # Move to the next step (idempotent at end)
  def advance_step
    @current_step = next_step_number
  end

  private

  def normalize(step)
    s = step.to_i
    return 1 if s < 1
    return total_steps if s > total_steps

    s
  rescue StandardError
    1
  end
end
