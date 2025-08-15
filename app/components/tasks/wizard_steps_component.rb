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
        'Category & Title',
        'Details',
        'Extra Info',
        'Photos'
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

    def status_item_classes(status)
      base = 'flex items-center gap-3 rounded-lg border px-4 py-3 transition shadow-sm'
      case status
      when :active
        merge_classes(base, 'border-violet-200 bg-violet-50 text-violet-700 font-medium')
      when :completed
        merge_classes(base,
                      'border-gray-200 bg-white text-gray-600 cursor-pointer hover:border-violet-300 hover:bg-violet-50')
      when :available
        merge_classes(base,
                      'border-gray-200 bg-white text-gray-600 cursor-pointer hover:border-violet-300 hover:bg-violet-50')
      when :locked
        merge_classes(base, 'border-gray-200 bg-gray-50 text-gray-400 opacity-60 cursor-not-allowed')
      else
        merge_classes(base, 'border-gray-200 bg-white text-gray-600')
      end
    end

    def status_badge_classes(status)
      base = 'flex h-8 w-8 items-center justify-center rounded-full text-sm font-semibold'
      case status
      when :active
        merge_classes(base, 'bg-violet-600 text-white')
      when :completed
        merge_classes(base, 'bg-violet-100 text-violet-600')
      when :available
        merge_classes(base, 'bg-gray-100 text-gray-500')
      when :locked
        merge_classes(base, 'bg-gray-200 text-gray-400')
      else
        merge_classes(base, 'bg-gray-100 text-gray-500')
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
