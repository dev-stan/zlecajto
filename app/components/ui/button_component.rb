# frozen_string_literal: true

module Ui
  # Renders a button, link, or form button with consistent styling and intent-revealing API.
  class ButtonComponent < ApplicationComponent
    VARIANTS = {
      primary: 'bg-primary text-white',
      glowing: 'bg-primary text-white glowing-btn',
      secondary: 'bg-secondary text-white',
      danger: 'bg-red-600 hover:bg-red-700 text-white',
      ghost: 'bg-white border-2 border-blue-900',
      text: 'bg-transparent text-black',
      success: 'bg-primary text-primary'
    }.freeze

    SIZES = {
      sm: 'px-3 py-1.5 text-base',
      md: 'px-4 py-2 text-base',
      lg: 'px-6 py-3 text-base'
    }.freeze

    WIDTHS = {
      nil => nil,
      25 => 'w-1/4',
      50 => 'w-1/2',
      75 => 'w-3/4',
      100 => 'w-full'
    }.freeze

    # Usage:
    # - As a submit button: set submit: true (legacy) or intent: :submit (preferred)
    # - As a regular button: set button: true (legacy) or intent: :button (preferred)
    # - As a link: provide path (and optionally method)
    #
    # Only one intent should be set at a time.
    #
    # For backward compatibility, submit: and button: are supported but intent: is preferred.
    def initialize(
      text:,
      path: nil,
      method: :get,
      variant: :primary,
      size: :md,
      submit: false,
      button: false,
      intent: nil, # :submit, :button, or nil (auto-detect)
      width: nil,
      html_options: {},
      text_align: :center # :left, :right, :center (default)
    )
      super()
      @text = text
      @path = path
      @method = method&.to_sym
      @variant = variant.to_sym
      @size = size.to_sym
      @width = width
      @html_options = html_options
      @submit = submit
      @button = button
      @text_align = text_align&.to_sym || :center
      @intent =
        if intent
          intent.to_sym
        elsif submit
          :submit
        elsif button
          :button
        end
    end

    # Public API for template
    def submit_button?
      intent == :submit
    end

    def regular_button?
      intent == :button
    end

    def link_button?
      path.present? && (!method || method == :get)
    end

    def form_button?
      path.present? && method && method != :get
    end

    attr_reader :text, :path, :method, :text_align

    # Used by template for option hashes
    def merged_button_options(default_type)
      opts = html_options.except(:class).dup
      opts[:type] ||= default_type
      opts[:class] = button_classes
      opts
    end

    def link_options
      html_options.merge(class: button_classes)
    end

    def button_to_options
      opts = html_options.dup
      opts[:class] = button_classes
      opts[:method] = method if method && method != :get
      opts
    end

    private

    attr_reader :variant, :size, :width, :html_options, :intent

    def button_classes
      align_class = case text_align
                    when :left then 'justify-start text-left'
                    when :right then 'justify-end text-right'
                    else 'justify-center text-center'
                    end
      merge_classes(
        'inline-flex items-center rounded-3xl font-medium transition-colors duration-700 outline-none ',
        align_class,
        VARIANTS[variant],
        SIZES[size],
        WIDTHS[width],
        html_options[:class]
      )
    end
  end
end
