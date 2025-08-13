class Shared::NavbarComponent < ViewComponent::Base
  include Devise::Controllers::Helpers if defined?(Devise)

  # A responsive, fixed top navigation bar with authentication support.
  # nav_items: array of { text:, href: } for left side navigation
  # search_action: form action for search (string path or URL)
  def initialize(nav_items: [], search_action: '#')
    @nav_items = nav_items.freeze
    @search_action = search_action
  end

  def user_signed_in?
    defined?(Devise) && helpers.user_signed_in?
  end

  def current_user
    helpers.current_user if user_signed_in?
  end

  private

  attr_reader :nav_items, :search_action
end