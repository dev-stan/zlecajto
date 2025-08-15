# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protected

  # Override Devise's after_sign_in_path to handle task creation flow
  def after_sign_in_path_for(resource)
    if session[:return_to]
      path = session[:return_to]
      session.delete(:return_to)
      path
    else
      super
    end
  end

  # Also handle after_sign_up_path for new registrations
  def after_sign_up_path_for(resource)
    if session[:return_to]
      path = session[:return_to]
      session.delete(:return_to)
      path
    else
      super
    end
  end
end
