class ApplicationController < ActionController::Base
  include LoginRedirect

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
end
