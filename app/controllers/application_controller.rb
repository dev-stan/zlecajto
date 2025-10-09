class ApplicationController < ActionController::Base
  include LoginRedirect
  before_action :set_whats_new_cookie
  before_action :ensure_persistent_login

  protected

  def after_sign_in_path_for(resource)
    pending_redirect_path || super
  end

  def after_sign_up_path_for(resource)
    pending_redirect_path || super
  end

  def after_omniauth_success_path_for(resource)
    pending_redirect_path || super
  end

  def set_whats_new_cookie
    @show_whats_new_modal = cookies[:whats_new_version] != WHATS_NEW_VERSION
  end

  private

  # Ensure users who were already logged in (without having checked "Remember me")
  # get a remember cookie after this deploy, without forcing a re-login.
  def ensure_persistent_login
    return unless defined?(Devise)
    return unless respond_to?(:user_signed_in?) && user_signed_in?

    # 1) If user was never remembered (no DB timestamp), create a remember token now.
    if current_user.respond_to?(:remember_created_at) && current_user.remember_created_at.blank?
      remember_me(current_user)
      return
    end

    # 2) If a remember token exists server-side but the browser cookie is missing
    #    (e.g., user cleared cookies), re-issue it to restore persistence.
    scope = Devise::Mapping.find_scope!(current_user)
    remember_cookie = "#{scope}_remember_token"
    remember_me(current_user) unless cookies.signed[remember_cookie].present?
  end
end
