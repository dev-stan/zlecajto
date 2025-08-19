# frozen_string_literal: true

class TaskWizard
  STEPS      = ['Tytuł i kategoria', 'Opis', 'Budżet', 'Zdjęcia'].freeze
  PERMITTED  = %i[category title description salary due_date timeslot payment_method].freeze

  attr_reader :current_step, :params_hash

  def initialize(step:, params:, advance: false)
    @current_step = normalize(step)
    raw = params || {}
    raw = raw.to_unsafe_h if raw.respond_to?(:to_unsafe_h)
    sym = raw.transform_keys(&:to_sym)
    @params_hash = sym.slice(*PERMITTED)
    advance_step if advance
  end

  def labels = STEPS
  def total_steps = STEPS.size
  def last_step? = current_step == total_steps
  def next_step_number = [current_step + 1, total_steps].min

  # Unsaved Task built from accumulated params
  def task
    @task ||= Task.new(params_hash)
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
