# frozen_string_literal: true

class ModalsController < ApplicationController
  # Clears the global modal frame
  def destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update('modal', '') }
      format.html { head :ok }
    end
  end
end
