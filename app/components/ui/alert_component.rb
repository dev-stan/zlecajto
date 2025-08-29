# frozen_string_literal: true

module Ui
  class AlertComponent < ApplicationComponent
    VARIANTS = {
      success: 'bg-green-50 border-green-200 text-green-800',
      error: 'bg-red-50 border-red-200 text-red-800',
      warning: 'bg-yellow-50 border-yellow-200 text-yellow-800',
      info: 'bg-blue-50 border-blue-200 text-blue-800'
    }.freeze

    def initialize(message:, variant: :success, auto_dismiss: true, html_options: {})
      @message = message
      @variant = variant.to_sym
      @auto_dismiss = auto_dismiss
      @html_options = html_options
    end

    def auto_dismiss?
      @auto_dismiss
    end

    private

    attr_reader :message, :variant, :html_options

    def variant_classes
      VARIANTS[variant] || VARIANTS[:info]
    end

    def alert_classes
      merge_classes(
        'fixed top-20 right-4 z-50 max-w-sm w-full border rounded-lg p-4 text-base leading-relaxed shadow-lg transition-all duration-500 ease-in-out',
        variant_classes,
        html_options[:class]
      )
    end
  end
end
