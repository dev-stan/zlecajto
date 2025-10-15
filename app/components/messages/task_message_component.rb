# frozen_string_literal: true

module Messages
  class TaskMessageComponent < ViewComponent::Base
    def initialize(message:, current_user:)
      super()
      @message = message
      @current_user = current_user
    end

    private

    attr_reader :message, :current_user

    def formatted_date(date)
      helpers.formatted_date(date)
    end
  end
end
