# frozen_string_literal: true

module Cards
  class MyTaskCardComponent < ApplicationComponent
    include TasksHelper

    def initialize(task:, show_actions: true, show_avatar: true, highlight: false, html_options: {},
                   path: nil)
      super()
      @task = task
      @show_avatar = show_avatar
      @show_actions = show_actions
      @highlight = highlight
      @html_options = html_options
      @path = path
    end

    private

    attr_reader :task, :show_actions, :highlight, :html_options, :path
  end
end
