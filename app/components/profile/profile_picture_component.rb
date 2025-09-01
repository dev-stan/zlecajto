# frozen_string_literal: true

module Profile
  class ProfilePictureComponent < ApplicationComponent
    def initialize(user:, size: 'md')
      super()
      @user = user
      @size = size
    end

    private

    def image_size
      case @size
      when 'sm'
        [40, 40]
      when 'md'
        [48, 48]
      when 'lg'
        [64, 64]
      else
        [48, 48]
      end
    end
  end
end
