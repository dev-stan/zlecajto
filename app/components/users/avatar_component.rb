# frozen_string_literal: true

module Users
  class AvatarComponent < ApplicationComponent
    def initialize(user:, size: 'md', show_notification: false, current_user: nil)
      super()
      @user = user
      @size = size
      @show_notification = show_notification
      @current_user = current_user
    end

    private

    def image_size
      case @size
      when 'sm'
        [36, 36]
      when 'md'
        [48, 48]
      when 'l'
        [64, 64]
      when 'lg'
        [128, 128]
      else
        [48, 48]
      end
    end
  end
end
