# frozen_string_literal: true

module Ui
  class CheckboxButtonComponent < ApplicationComponent
    attr_reader :name, :value, :checked, :id, :label, :options, :color

    COLOR_CLASSES = {
      'red' => {
        hover: 'hover:bg-red-200',
        checked: 'peer-checked:bg-red-300 peer-checked:text-red-900 peer-checked:border-2 peer-checked:border-red-700',
        base: 'bg-red-100 text-red-700'
      },
      'blue' => {
        hover: 'hover:bg-blue-200',
        checked: 'peer-checked:bg-blue-300 peer-checked:text-blue-900 peer-checked:border-2 peer-checked:border-blue-700',
        base: 'bg-blue-100 text-blue-700'
      },
      'green' => {
        hover: 'hover:bg-green-200',
        checked: 'peer-checked:bg-green-300 peer-checked:text-green-900 peer-checked:border-2 peer-checked:border-green-700',
        base: 'bg-green-100 text-green-700'
      },
      'purple' => {
        hover: 'hover:bg-purple-200',
        checked: 'peer-checked:bg-purple-300 peer-checked:text-purple-900 peer-checked:border-2 peer-checked:border-purple-700',
        base: 'bg-purple-100 text-purple-700'
      },
      'pink' => {
        hover: 'hover:bg-pink-200',
        checked: 'peer-checked:bg-pink-300 peer-checked:text-pink-900 peer-checked:border-2 peer-checked:border-pink-700',
        base: 'bg-pink-100 text-pink-700'
      },
      'yellow' => {
        hover: 'hover:bg-yellow-200',
        checked: 'peer-checked:bg-yellow-300 peer-checked:text-yellow-900 peer-checked:border-2 peer-checked:border-yellow-500',
        base: 'bg-yellow-100 text-yellow-700'
      },
      'orange' => {
        hover: 'hover:bg-orange-200',
        checked: 'peer-checked:bg-orange-300 peer-checked:text-orange-900 peer-checked:border-2 peer-checked:border-orange-500',
        base: 'bg-orange-100 text-orange-700'
      },
      'teal' => {
        hover: 'hover:bg-teal-200',
        checked: 'peer-checked:bg-teal-300 peer-checked:text-teal-900 peer-checked:border-2 peer-checked:border-teal-500',
        base: 'bg-teal-100 text-teal-700'
      },
      'indigo' => {
        hover: 'hover:bg-indigo-200',
        checked: 'peer-checked:bg-indigo-300 peer-checked:text-indigo-900 peer-checked:border-2 peer-checked:border-indigo-500',
        base: 'bg-indigo-100 text-indigo-700'
      },
      'lime' => {
        hover: 'hover:bg-lime-200',
        checked: 'peer-checked:bg-lime-300 peer-checked:text-lime-900 peer-checked:border-2 peer-checked:border-lime-500',
        base: 'bg-lime-100 text-lime-700'
      }
    }.freeze

    def initialize(name:, value:, checked: false, id: nil, label: nil, random_color: false, color: nil,
                   html_options: {})
      super()
      @name = name
      @value = value
      @checked = checked
      @id = id || "checkbox_#{name}_#{value}".parameterize
      @label = label || value
      @options = html_options

      # Determine the color based on the random_color flag and provided color.
      @color = if random_color
                 COLOR_CLASSES.keys.sample
               elsif color.present? && COLOR_CLASSES.key?(color.to_s)
                 color.to_s
               else
                 'blue' # Default color if neither random nor a valid color is provided.
               end
    end

    def render_label_classes
      base_classes = 'flex items-center justify-center gap-2 px-4 py-2 text-base font-medium text-gray-700 rounded-4xl'
      custom_classes = options[:class].to_s.split

      classes_for_color = COLOR_CLASSES[@color]

      [
        base_classes,
        classes_for_color[:hover],
        classes_for_color[:checked],
        classes_for_color[:base],
        custom_classes
      ].flatten.compact.join(' ')
    end
  end
end
