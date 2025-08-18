# frozen_string_literal: true

module Tasks
  class WizardStepsComponent < ApplicationComponent
    # Renders the vertical step list for the task creation wizard
    # current_step: Integer (1-based)
    # steps: Array of label strings (optional override)
    # task: current (unsaved) Task instance to preserve entered data when navigating
    def initialize(current_step:, task:, steps: default_steps)
      super()
      @current_step = current_step.to_i
      @task = task
      @steps = steps
    end

    private

    attr_reader :current_step, :steps, :task

    def default_steps
      [
        'Tytuł i kategoria',
        'Opis',
        'Budżet',
        'Zdjęcia'
      ]
    end

    # Unified status for a step: :active, :completed (past), :available (future & unlocked), :locked (future & blocked)
    def step_status(number)
      return :active if number == current_step
      return :completed if number < current_step
      return :locked unless prerequisites_met?(number)

      :available
    end

    def prerequisites_met?(number)
      case number
      when 2
        task_wizard_params[:category].present? && task_wizard_params[:title].present?
      when 3
        prerequisites_met?(2) # could add more specific checks later
      when 4
        prerequisites_met?(3)
      else
        true
      end
    end

    def task_wizard_params
      return {} unless task

      {
        category: task.category,
        title: task.title,
        description: task.description,
        salary: task.salary
      }.compact
    end

    def step_path(number)
      helpers.new_task_path(step: number, task: task_wizard_params)
    end

    def previous_step_path
      step_path(current_step - 1) if current_step > 1
    end
  end
end
