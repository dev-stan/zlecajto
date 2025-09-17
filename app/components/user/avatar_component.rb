# frozen_string_literal: true

class User::AvatarComponent < ApplicationComponent
  def initialize(user:, size: 'md')
    super()
    @user = user
    @size = size
  end

  private

  def image_size
    case @size
    when 'sm'
      [36, 36]
    when 'md'
      [48, 48]
    when 'lg'
      [128, 128]
    else
      [48, 48]
    end
  end
end
