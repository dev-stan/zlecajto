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

    def has_accepted_submissions?
      return false unless user_signed_in?

      current_user.has_unseen_accepted_submissions?
    end
  end
end
