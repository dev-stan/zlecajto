class Ui::InputComponent < ApplicationComponent
  def initialize(name:, type: 'text', label: nil, placeholder: nil, required: false, disabled: false, value: nil, rows: 5, html_options: {})
    @name = name
    @type = type
    @label = label
    @placeholder = placeholder
    @required = required
    @disabled = disabled
    @value = value
    @rows = rows
    @html_options = html_options
    @id = generate_id
  end

  private

  attr_reader :name, :type, :label, :placeholder, :required, :disabled, :value, :rows, :html_options, :id

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
    'mb-1 block text-sm font-medium text-gray-700'
  end

  def input_classes
    merge_classes(
      'block w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm placeholder-gray-400 shadow-sm transition focus:border-violet-500 focus:ring focus:ring-violet-200 focus:ring-opacity-50 focus:outline-none',
      disabled ? 'bg-gray-100 cursor-not-allowed' : nil,
      html_options[:class]
    )
  end

  def input_attributes
    {
      id: id,
      name: name,
      placeholder: placeholder,
      class: input_classes,
      disabled: disabled || nil,
      required: required || nil
    }.merge(html_options.except(:class))
  end
end
