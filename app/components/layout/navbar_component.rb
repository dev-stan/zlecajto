# frozen_string_literal: true

module Layout
  class NavbarComponent < ApplicationComponent
    def initialize(nav_items: [])
      super()
      @nav_items = nav_items # Array of simple hashes: { text: 'X', href: '/x' }
    end

    # --- Simplified helpers ---
    def greeting_text
      return unless user_signed_in?

      "Witaj, #{current_user.email.split('@').first}!"
    end

    NAV_LINK_CLASSES = 'inline-flex items-center rounded-md px-2 sm:px-3 py-2 text-xs sm:text-sm font-medium text-slate-700 hover:text-violet-600 hover:bg-violet-50 focus:outline-none focus:ring-2 focus:ring-violet-500 focus:ring-offset-2 transition-colors'
    PRIMARY_ACTION_LINK_CLASSES = 'inline-flex items-center rounded-md px-2 sm:px-3 py-2 text-xs sm:text-sm font-medium bg-violet-600 text-white hover:bg-violet-700 focus:outline-none focus:ring-2 focus:ring-violet-500 focus:ring-offset-2 transition-colors'

    # Basic auth state helpers
    def user_signed_in?
      defined?(Devise) && helpers.user_signed_in?
    end

    def current_user
      helpers.current_user if user_signed_in?
    end

    def left_nav_items
      Array(@nav_items).select { |h| h.is_a?(Hash) && h[:text].present? && h[:href].present? }
    end

    def logout_button_classes
      'inline-flex items-center rounded-md px-2 sm:px-3 py-2 text-xs sm:text-sm font-medium text-red-600 hover:text-red-700 hover:bg-red-50 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 transition-colors'
    end

    def accepted_submissions?
      return false unless user_signed_in?

      current_user.has_unseen_accepted_submissions?
    end

    def nav_link_classes = NAV_LINK_CLASSES
    def primary_action_link_classes = PRIMARY_ACTION_LINK_CLASSES
  end
end
