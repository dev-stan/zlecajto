# frozen_string_literal: true

module Layout
  class NavbarComponent < ApplicationComponent
    # Basic auth state helpers
    def user_signed_in?
      defined?(Devise) && helpers.user_signed_in?
    end

    def current_user
      helpers.current_user if user_signed_in?
    end
  end
end
