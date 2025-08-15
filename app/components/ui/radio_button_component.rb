class Ui::RadioButtonComponent < ApplicationComponent
  def initialize(name:, value:, checked: false, id: nil, label: nil, html_options: {})
    @name = name
    @value = value
    @checked = checked
    @id = id || generate_id
    @label = label
    @options = html_options
  end

  private

  attr_reader :name, :value, :checked, :id, :label, :options

  def generate_id
    "#{name.to_s.parameterize}_#{value.to_s.parameterize}"
  end
end
