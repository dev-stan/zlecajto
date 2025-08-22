# frozen_string_literal: true

module Ui
  class ButtonComponent < ApplicationComponent
    VARIANTS = {
      primary: 'bg-primary text-primary',
      secondary: 'bg-secondary text-secondary border border-gray-300',
      danger: 'bg-red-600 hover:bg-red-700 text-white',
      ghost: 'bg-transparent hover:bg-secondary text-primary',
      success: 'bg-primary text-primary'
    }.freeze

    SIZES = {
      sm: 'px-3 py-1.5 text-sm',
      md: 'px-4 py-2 text-sm',
      lg: 'px-6 py-3 text-base'
    }.freeze

    WIDTHS = {
      nil => nil,
      25 => 'w-1/4',
      50 => 'w-1/2',
      75 => 'w-3/4',
      100 => 'w-full'
    }.freeze

    def initialize(text:, path: nil, variant: :primary, size: :md, submit: false, button: false, width: nil,
                   html_options: {})
      super()
      @text = text
      @path = path
      @variant = variant.to_sym
      @size = size.to_sym
      @submit = submit
      @button = button
      @width = width
      @html_options = html_options
    end

    def submit?
      !!@submit
    end

    def button?
      !!@button
    end

    private

    attr_reader :text, :path, :variant, :size, :width, :html_options

    def button_classes
      merge_classes(
        'inline-flex items-center justify-center text-center rounded-3xl font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed',
        VARIANTS[variant],
        SIZES[size],
        WIDTHS[width],
        html_options[:class]
      )
    end

    def link_options
      html_options.merge(class: button_classes)
    end

    def merged_button_options(default_type)
      opts = html_options.except(:class).dup
      # Preserve existing type if provided explicitly
      opts[:type] ||= default_type
      opts[:class] = button_classes
      opts
    end
  end
end
