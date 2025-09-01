# frozen_string_literal: true

module Profile
  class ProfileReviewsComponent < ApplicationComponent
    def initialize(user:)
      super()
      @user = user
    end
  end
end
