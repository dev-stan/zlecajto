# frozen_string_literal: true

module Layout
  class NavbarComponent < ApplicationComponent
    def initialize(current_user:, user_signed_in:)
      super()
      @current_user = current_user
      @user_signed_in = user_signed_in
    end
  end
end
