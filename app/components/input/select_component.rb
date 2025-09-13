class Input::SelectComponent < ViewComponent::Base
  def initialize(form:, field:, options:, selected: nil, label: 'Wybierz kategorię')
    @form = form
    @field = field
    @options = options
    @selected = selected
    @label = label
  end
end
