class Shared::NavbarComponent < ViewComponent::Base
  # A responsive, fixed top navigation bar.
  # nav_items: array of { text:, href: }
  # show_search: toggles rendering of SearchComponent
  # search_action: form action for search (string path or URL)
  def initialize(nav_items: [], search_action: '#')
    @nav_items = nav_items.freeze
    @search_action = search_action
  end

  private

  attr_reader :nav_items, :search_action
end