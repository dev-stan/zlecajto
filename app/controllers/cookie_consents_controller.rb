# frozen_string_literal: true

class CookieConsentsController < ApplicationController
  skip_before_action :check_cookie_consent

  def create
    consent_level = case params[:consent_type]
                    when 'accept_all'
                      'all'
                    when 'reject_all', 'reject_non_essential'
                      'essential'
                    when 'save_preferences'
                      params[:statistics] == '1' ? 'all' : 'essential'
                    else
                      'essential'
                    end

    cookies.permanent[:cookie_consent_level] = consent_level
    
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
    end
  end
end
