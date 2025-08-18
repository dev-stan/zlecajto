# frozen_string_literal: true

module Ui
  class ButtonComponent < ApplicationComponent
    VARIANTS = {
      primary: 'bg-violet-600 hover:bg-violet-700 text-white',
      secondary: 'bg-white hover:bg-gray-50 text-gray-900 border border-gray-300',
      danger: 'bg-red-600 hover:bg-red-700 text-white',
      ghost: 'bg-transparent hover:bg-gray-100 text-gray-900',
      success: 'bg-green-600 hover:bg-green-700 text-white'
    }.freeze

    SIZES = {
      sm: 'px-3 py-1.5 text-sm',
      md: 'px-4 py-2 text-sm',
      lg: 'px-6 py-3 text-base'
    }.freeze

    def initialize(text:, path: nil, variant: :primary, size: :md, submit: false, button: false, html_options: {})
      super()
      @text = text
      @path = path
      @variant = variant.to_sym
      @size = size.to_sym
      @submit = submit
      @button = button
      @html_options = html_options
    end

    def submit?
      !!@submit
    end

    def button?
      !!@button
    end

    private

    attr_reader :text, :path, :variant, :size, :html_options

    def button_classes
      merge_classes(
        'inline-flex items-center justify-center rounded-md font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed',
        VARIANTS[variant],
        SIZES[size],
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
