# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(resource)
    pending_redirect_path || super
  end

  def after_sign_up_path_for(resource)
    pending_redirect_path || super
  end

  # Add this for OAuth flows
  def after_omniauth_success_path_for(resource)
    pending_redirect_path || super
  end

  private

  def pending_redirect_path
    if PendingSubmission.present?(session)
      create_from_session_submissions_path
    elsif PendingTask.present?(session)
      create_from_session_task_path
    elsif session[:return_to].present?
      return_path = session[:return_to]
      session.delete(:return_to)
      return_path
    end
  end
end
