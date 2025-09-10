# frozen_string_literal: true

module Layout
  class BurgerMenuComponent < ViewComponent::Base
    def initialize(user_signed_in:, current_user:, has_accepted_submissions:)
      super()
      @user_signed_in = user_signed_in
      @current_user = current_user
      @has_accepted_submissions = has_accepted_submissions
    end
  end
end
