# frozen_string_literal: true

module Ui
  class BadgeComponent < ApplicationComponent
    VARIANTS = {
      green: 'bg-green-100 text-green-800 border-green-200',
      red: 'bg-red-100 text-red-800 border-red-200',
      blue: 'bg-blue-100 text-blue-800 border-blue-200',
      yellow: 'bg-yellow-100 text-yellow-800 border-yellow-200',
      gray: 'bg-gray-100 text-gray-800 border-gray-200',
      violet: 'bg-violet-100 text-violet-800 border-violet-200'
    }.freeze

    def initialize(text:, variant: :gray, html_options: {})
      @text = text
      @variant = variant.to_sym
      @html_options = html_options
    end

    private

    attr_reader :text, :variant, :html_options

    def badge_classes
      merge_classes(
        'inline-flex items-center px-2.5 py-0.5 rounded-full text-base font-medium border',
        VARIANTS[variant] || VARIANTS[:gray],
        html_options[:class]
      )
    end
  end
end
