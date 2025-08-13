class InputComponent < ViewComponent::Base
  def initialize(name:, type: 'text', label: nil, placeholder: nil, required: false, disabled: false, value: nil, rows: 5)
    @name        = name
    @type        = type
    @label       = label
    @placeholder = placeholder
    @required    = required
    @disabled    = disabled
    @value       = value
    @rows        = rows
    @id          = generate_id
  end

  private

  def generate_id
    base = @name.to_s.parameterize(separator: '_')
    "input_#{base}"
  end
end
