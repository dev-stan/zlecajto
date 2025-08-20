# frozen_string_literal: true

module Cards
  class CardComponent < ApplicationComponent
    # Usage: render Ui::CardComponent.new do ... end
    # Optional: title:, padding:, shadow:, border:, rounded:, html_options:

    DEFAULT_BASE = 'rounded-2xl border border-gray-200 shadow-sm'

    def initialize(title: nil, padding: :md, shadow: true, border: true, rounded: true, html_options: {})
      super()
      @title = title
      @padding = padding
      @shadow = shadow
      @border = border
      @rounded = rounded
      @html_options = html_options
    end

    private

    attr_reader :title, :padding, :shadow, :border, :rounded, :html_options

    def wrapper_classes
      merge_classes(
        DEFAULT_BASE,
        padding_class,
        (shadow ? '' : 'shadow-none'),
        (border ? '' : 'border-0'),
        (rounded ? '' : 'rounded-none'),
        html_options[:class]
      )
    end

    def padding_class
      case padding
      when :sm then 'p-3'
      when :md then 'p-5'
      when :lg then 'p-7'
      else padding.to_s
      end
    end
  end
end
