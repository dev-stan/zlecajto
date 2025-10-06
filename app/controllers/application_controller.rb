class ApplicationController < ActionController::Base
  include LoginRedirect
  before_action :set_whats_new_cookie

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
end
