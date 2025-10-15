# frozen_string_literal: true

class ModalsController < ApplicationController
  # GET /users/sign_out/confirm
  def confirm_logout
    respond_to(&:html)
  end

  # GET /submissions/:id/confirm_accept
  def confirm_submission_accept
    @submission = Submission.find(params[:id])
    respond_to(&:html)
  end

  # GET /tasks/:id/confirm_complete
  def confirm_task_complete
    @task = Task.find(params[:id])
    respond_to(&:html)
  end

  # GET /tasks/:id/delete_modal
  def confirm_delete_task
    @task = Task.find(params[:id])
    respond_to(&:html)
  end

  # GET /tasks/:id/edit_modal
  def edit_task
    @task = Task.find(params[:id])
    respond_to(&:html)
  end

  # GET /users/profile/edit_modal
  def edit_profile
    @user = current_user
    respond_to(&:html)
  end

  # GET /submissions/:id/answer_modal
  def new_answer
    @submission = Submission.find(params[:id])
    @answer = Answer.new(submission: @submission)
    unless current_user && (current_user.id == @submission.user_id || current_user.id == @submission.task.user_id)
      head :forbidden and return
    end

    respond_to(&:html)
  end

  # GET /tasks/:id/task_message_modal
  def new_task_message
    @task = Task.find(params[:id])
    @task_message = TaskMessage.new(task: @task, message_type: :question)

    respond_to(&:html)
  end

  # GET /task_messages/:id/reply_modal
  def reply_task_message
    @parent_message = TaskMessage.find(params[:id])
    @task = @parent_message.task
    @task_message = TaskMessage.new(task: @task, parent: @parent_message, message_type: :reply)
    root_author = @parent_message.thread_root.user
    head :forbidden and return unless current_user && (current_user == @task.user || current_user == root_author)

    respond_to(&:html)
  end

  # Clears the global modal frame
  def destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update('modal', '') }
      format.html { head :ok }
    end
  end
end
