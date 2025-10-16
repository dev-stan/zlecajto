# frozen_string_literal: true

module Ui
  class RadioButtonComponent < ApplicationComponent
    CATEGORIES = %w[Zwierzaki Naprawy Ogród Transport Korki Sprzęt Przeprowadzki Sprzątanie Rower Inne].freeze
    CATEGORY_EMOJIS = {
      'Zwierzaki' => '🐾',
      'Naprawy' => '🔧',
      'Ogród' => '🌿',
      'Transport' => '🚚',
      'Korki' => '📚',
      'Eventy' => '🎉',
      'Przeprowadzki' => '📦',
      'Sprzątanie' => '🧹',
      'Rower' => '🚴‍♂️',
      'Inne' => '✨'
    }.freeze

    PAYMENT_METHODS_EMOJIS = {
      'Przelew' => '💳',
      'Blik' => '📱',
      'Gotówka' => '💵',
      'Czekolada' => '🍫'
    }.freeze

    TIMESLOT_EMOJIS = {
      'Rano' => '🌅',
      'Popołudnie' => '☀️',
      'Wieczór' => '🌙'
    }.freeze

    # Provide a fallback emoji for the due date "Obojętnie" label as well

    def initialize(name:, value:, checked: false, id: nil, label: nil, style: :default, html_options: {})
      super()
      @name = name
      @value = value
      @checked = checked
      @id = id.presence || build_id
      @label = label
      @style = style.to_sym
      @options = html_options
    end

    private

    attr_reader :name, :value, :checked, :id, :label, :style, :options

    def build_id
      [name, value].map { |v| v.to_s.parameterize }.join('_')
    end

    def display_emoji
      CATEGORY_EMOJIS[label] || TIMESLOT_EMOJIS[value.to_s] || PAYMENT_METHODS_EMOJIS[label] || ''
    end
  end
end
