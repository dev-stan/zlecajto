# frozen_string_literal: true

module Tasks
  class CancelService
    def initialize(task)
      @task = task
    end

    def call
      return if @task.cancelled?

      @task.update!(status: :cancelled)
    end
  end
end
