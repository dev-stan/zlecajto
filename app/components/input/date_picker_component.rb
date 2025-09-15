# frozen_string_literal: true

module Input
  class DatePickerComponent < ApplicationComponent
    attr_reader :name, :label, :value, :disabled, :html_options, :id

    def initialize(name:, label: nil, value: nil, disabled: false, html_options: {})
      super()
      @name = name
      @label = label
      @value = value
      @disabled = disabled
      @html_options = html_options
      @id = "datepicker_#{name.to_s.parameterize(separator: '_')}"
    end

    def formatted_value
      return if value.blank?

      v = value.respond_to?(:to_date) ? value.to_date : value
      v.is_a?(Date) ? v.strftime('%Y-%m-%d') : v.to_s
    end

    def input_options
      html_options.merge(
        id: id,
        name: name,
        type: 'date',
        value: formatted_value,
        disabled: disabled ? true : nil
      ).compact
    end
  end
end
