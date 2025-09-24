# app/controllers/modals_controller.rb
class ModalsController < ApplicationController
  def destroy
    respond_to do |format|
  # Clear the modal frame content but keep the frame in the DOM
  format.turbo_stream { render turbo_stream: turbo_stream.update('modal', '') }
  # Safe no-op fallback
  format.html { head :ok }
    end
  end
end