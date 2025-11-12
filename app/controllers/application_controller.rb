# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include LoginRedirect
  before_action :set_whats_new_cookie
  before_action :ensure_persistent_login
  before_action :set_current_user
  before_action :update_user_last_seen_at, if: :user_signed_in?
  after_action :set_user_cookie

  protected

  def set_current_user
    Current.user = current_user
  end

  def set_user_cookie
    cookies.signed[:user_id] = current_user.id if current_user
  end

  def after_sign_in_path_for(resource)
    pending_redirect_path || super
  end

  def after_omniauth_success_path_for(resource)
    pending_redirect_path || super
  end

  def set_whats_new_cookie
    @show_whats_new_modal = cookies[:whats_new_version] != WHATS_NEW_VERSION
  end

  private

  # Ensure users who were already logged in without having checked "Remember me"
  # get a remember cookie after this deploy, without forcing a re-login.
  def ensure_persistent_login
    return unless defined?(Devise)
    return unless respond_to?(:user_signed_in?) && user_signed_in?

    # 1 If user was never remembered (no DB timestamp), create a remember token now.
    if current_user.respond_to?(:remember_created_at) && current_user.remember_created_at.blank?
      sign_in(current_user, remember_me: true)
      return
    end

    # 2 If a remember token exists server-side but the browser cookie is missing
    #    e.g., user cleared cookies), re-issue it to restore persistence.
    scope = Devise::Mapping.find_scope!(current_user)
    remember_cookie = "#{scope}_remember_token"
    sign_in(current_user, remember_me: true) unless cookies.signed[remember_cookie].present?
  end

  def update_user_last_seen_at
    # Only update if more than 5 minutes have passed
    if current_user.last_seen_at.nil? || current_user.last_seen_at < 5.minutes.ago
      current_user.update_column(:last_seen_at, Time.current)
    end
  end
end
