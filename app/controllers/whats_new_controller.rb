# frozen_string_literal: true

class WhatsNewController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :dismiss

  # POST /whats_new/dismiss
  def dismiss
    cookies[:whats_new_version] = {
      value: WHATS_NEW_VERSION,
      expires: 1.year.from_now,
      same_site: :lax
    }

    respond_to do |format|
      format.turbo_stream { head :ok }
      format.json { head :ok }
      format.html { head :ok }
    end
  end
end
