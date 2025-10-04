# frozen_string_literal: true

module Tasks
  class WizardStepsComponent < ApplicationComponent
    # Renders the vertical step list for the task creation wizard
    # current_step: Integer (1-based)
    # steps: Array of label strings (optional override)
    # task: current (unsaved) Task instance to preserve entered data when navigating
    def initialize(current_step:, task:, steps:)
      super()
      @current_step = current_step.to_i
      @task = task
      @steps = steps
    end

    private

    attr_reader :current_step, :steps, :task

    # Unified status for a step: :active, :completed (past), :available (future & unlocked), :locked (future & blocked)
    def step_status(number)
      return :active if number == current_step
      return :completed if number < current_step
      return :locked unless prerequisites_met?(number)

      :available
    end

    def prerequisites_met?(number)
      return true if number <= 1
      return false unless task&.category.present? && task.title.present?

      true
    end

    def step_path(_number)
      '#'
    end

    def previous_step_path
      '#'
    end

    def preserved_params
      return {} unless task

      task.slice(:category, :title, :description, :salary, :due_date, :timeslot, :payment_method, :location).compact
    end
  end
end
