# frozen_string_literal: true

class ModalsController < ApplicationController
  # GET /users/sign_out/confirm
  def confirm_logout
    respond_to do |format|
      format.html
    end
  end

  # GET /submissions/:id/confirm_accept
  def confirm_submission_accept
    @submission = Submission.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # GET /tasks/:id/confirm_complete
  def confirm_task_complete
    @task = Task.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # GET /tasks/:id/edit_modal
  def edit_task
    @task = Task.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # Clears the global modal frame
  def destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update('modal', '') }
      format.html { head :ok }
    end
  end
end
