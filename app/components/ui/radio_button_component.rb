# frozen_string_literal: true

module Ui
  class RadioButtonComponent < ApplicationComponent
    CATEGORY_EMOJIS = {
  'Sprzątanie' => '🧹',      # cleaning
  'Zakupy' => '🛒',          # shopping
  'Montaż' => '🛠️',         # assembly / installation
  'Transport' => '🚗',       # transport
  'Przeprowadzki' => '📦',   # moving
  'Opieka' => '🤝',          # care / assistance
  'Naprawy' => '🔧',         # repairs
  'Ogrodnictwo' => '🌿'      # gardening
    }.freeze

    PAYMENT_METHODS_EMOJIS = {
      'Przelew' => '💳',
      'Blik' => '📱',
      'Gotówka' => '💵'
    }.freeze

    TIMESLOT_EMOJIS = {
      'Rano' => '🌅',
      'Popołudnie' => '☀️',
      'Wieczór' => '🌙'
    }.freeze

    def initialize(name:, value:, checked: false, id: nil, label: nil, style: :default,
                   html_options: {})
      super()
      @name = name
      @value = value
      @checked = checked
      @id = id || generate_id
      @label = label
      @style = style.to_sym
      @options = html_options
    end

    private

    attr_reader :name, :value, :checked, :id, :label, :style, :options

    def generate_id
      "#{name.to_s.parameterize}_#{value.to_s.parameterize}"
    end

    def display_emoji
      return CATEGORY_EMOJIS[label] if CATEGORY_EMOJIS.key?(label)
      return TIMESLOT_EMOJIS[value.to_s] if TIMESLOT_EMOJIS.key?(value.to_s)
      return PAYMENT_METHODS_EMOJIS[label] if PAYMENT_METHODS_EMOJIS.key?(label)

      ''
    end
  end
end
