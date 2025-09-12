# frozen_string_literal: true

module Input
  class InputComponent < ApplicationComponent
    def initialize(name:, type: 'text', label: nil, placeholder: nil, disabled: false, value: nil,
                   rows: 5, html_options: {})
      super()
      @name = name
      @type = type
      @label = label
      @placeholder = placeholder
      @disabled = disabled
      @value = value
      @rows = rows
      @html_options = html_options
      @id = generate_id
    end

    private

    attr_reader :name, :type, :label, :placeholder, :disabled, :value, :rows, :html_options, :id

    def render_input
      if type == 'textarea'
        content_tag(:textarea, value, input_attributes.merge(rows: rows))
      else
        tag(:input, input_attributes.merge(type: type, value: value))
      end
    end

    def generate_id
      base = name.to_s.parameterize(separator: '_')
      "input_#{base}"
    end

    def label_classes
      'mb-1 block text-base font-medium text-gray-700'
    end

    def input_classes
      merge_classes(
        'block rounded-lg bg-white px-3 py-3 text-base placeholder-gray-400 transition focus:border-green-500 focus:ring focus:ring-green-200 focus:ring-opacity-50 focus:outline-none',
        disabled ? 'bg-white cursor-not-allowed' : nil,
        html_options[:class]
      )
    end

    def input_attributes
      {
        id: id,
        name: name,
        placeholder: placeholder,
        class: input_classes,
        disabled: disabled || nil
      }.merge(html_options.except(:class))
    end
  end
end
