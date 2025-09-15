class Input::SelectComponent < ViewComponent::Base
  def initialize(form:, field:, options:, selected: nil, label: 'Wybierz kategorię', html_options: {})
    @form = form
    @field = field
    @options = options
    @selected = selected
    @label = label
    @html_options = html_options || {}
  end
end
