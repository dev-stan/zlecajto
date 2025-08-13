class SearchComponent < ViewComponent::Base
  # Simple search form (GET) with a single query field.
  def initialize(action: '#', placeholder: 'Search…', param: 'q')
    @action = action
    @placeholder = placeholder
    @param = param
  end
end