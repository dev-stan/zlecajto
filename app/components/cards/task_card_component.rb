# frozen_string_literal: true

module Cards
  class TaskCardComponent < ApplicationComponent
    include TasksHelper

    def initialize(task:, show_actions: true, show_image: true, highlight: false, html_options: {}, path: nil)
      super()
      @task = task
      @show_actions = show_actions
      @show_image = show_image
      @highlight = highlight
      @html_options = html_options
      @path = path
    end

    private

    attr_reader :task, :show_actions, :show_image, :highlight, :html_options, :path
  end
end
