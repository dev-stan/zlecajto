# frozen_string_literal: true

class User::AvatarComponent < ApplicationComponent
  def initialize(user:, size: 'md', show_notification: false)
    super()
    @user = user
    @size = size
    @show_notification = show_notification
  end

  private
  # [todo] current user should be defined more top-level, not in each component
  def user_signed_in?
    defined?(Devise) && helpers.user_signed_in?
  end

  def current_user
    helpers.current_user if user_signed_in?
  end

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
