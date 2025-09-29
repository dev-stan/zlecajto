# frozen_string_literal: true

module Tasks
  #  - :default (title first, badge under)
  #  - :owner   (badge first, title under)
  class TaskCardComponent < ApplicationComponent
    include ActionView::Helpers::DateHelper

    renders_one  :image
    renders_many :badges

    attr_reader :task, :variant, :path

    def initialize(task:, path: nil, variant: :default, show_notification: false)
      super()
      @task = task
      @path = path
      @variant = variant.to_sym
      @show_notification = show_notification
    end
    

    def user_signed_in?
      defined?(Devise) && helpers.user_signed_in?
    end

    def current_user
      helpers.current_user if user_signed_in?
    end

    private

    # helper methods
    def badges_before_title?
      variant == :owner
    end

    # dynamic classes
    def title_classes
      base = 'text-xl font-semibold text-gray-900 mb-2'
      badges_before_title? ? "#{base} mt-4" : base
    end
  end
end
