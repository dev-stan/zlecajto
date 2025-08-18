# frozen_string_literal: true

module Ui
  class DatePickerComponent < ApplicationComponent
    def initialize(name:, label: nil, value: nil, required: false, disabled: false, html_options: {})
      super()
      @name = name
      @label = label
      @value = value
      @required = required
      @disabled = disabled
      @html_options = html_options
      @id = generate_id
    end

    private

    attr_reader :name, :label, :value, :required, :disabled, :html_options, :id

    def generate_id
      "datepicker_#{name.to_s.parameterize(separator: '_')}"
    end

    def label_classes
      'mb-1 block text-sm font-medium text-gray-700'
    end

    def input_classes
      merge_classes(
        'block rounded-md bg-gray-100 px-3 py-2 text-sm transition focus:border-green-500 focus:ring focus:ring-green-200 focus:ring-opacity-50 focus:outline-none',
        disabled ? 'bg-gray-100 cursor-not-allowed' : nil,
        html_options[:class]
      )
    end

    def input_attributes
      {
        id: id,
        name: name,
        type: 'date',
        value: formatted_value,
        class: input_classes,
        disabled: disabled || nil,
        required: required || nil
      }.merge(html_options.except(:class))
    end

    def formatted_value
      return unless value.present?

      v = value.respond_to?(:to_date) ? value.to_date : value
      v.is_a?(Date) ? v.strftime('%Y-%m-%d') : v.to_s
    end
  end
end
