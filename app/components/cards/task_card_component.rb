# frozen_string_literal: true

module Cards
  class TaskCardComponent < ApplicationComponent
    include TasksHelper

    def initialize(task:, show_avatar: true, show_image: true, html_options: {},
                   path: nil)
      super()
      @task = task
      @show_avatar = show_avatar
      @show_image = show_image
      @html_options = html_options
      @path = path
    end

    private

    attr_reader :task, :show_image, :html_options, :path
  end
end
