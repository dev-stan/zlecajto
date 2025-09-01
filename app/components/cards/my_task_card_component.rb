# frozen_string_literal: true

module Cards
  class MyTaskCardComponent < ApplicationComponent
    include TasksHelper

    def initialize(task:)
      super()
      @task = task
    end
  end
end
