# frozen_string_literal: true

class TaskMessagesController < ApplicationController
  before_action :set_task, only: %i[create]
  before_action :authenticate_user!, except: %i[create create_from_session]

  def create
    return store_pending_message_and_redirect unless user_signed_in?

    task_message = TaskMessages::Creator.new(user: current_user, task: @task, params: task_message_params).call
    handle_message_save(task_message)
  end

  def create_from_session
    @task_message = PendingTaskMessage.create_for_user(current_user, session)

    if @task_message&.persisted?
      @task = @task_message.task
      respond_to do |format|
        format.turbo_stream { redirect_to @task, notice: 'Wiadomość została dodana.' }
        format.html { redirect_to @task, notice: 'Wiadomość została dodana.' }
      end
    else
      handle_message_failure(alert: 'Coś poszło nie tak, spróbuj ponownie...', fallback: root_path)
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def task_message_params
    # Allow direct uploads via ActiveStorage on :photos
    params.require(:task_message).permit(:body, :parent_id, :message_type, photos: [])
  end

  def handle_message_save(task_message)
    if task_message.save
      handle_message_success
    else
      handle_message_error(task_message)
    end
  end

  def handle_message_success
    respond_to do |format|
      format.turbo_stream { render turbo_stream: success_turbo_streams }
      format.html { redirect_to @task, notice: 'Wiadomość została dodana.' }
    end
  end

  def handle_message_error(task_message)
    respond_to do |format|
      # Ensure views have the expected instance variable
      @task_message = task_message

      format.turbo_stream do
        # Re-render the modal content inside the global 'modal' frame
        html = render_to_string(template: error_template_for(task_message), formats: [:html])
        render turbo_stream: turbo_stream.update('modal', html), status: :unprocessable_entity
      end
      format.html do
        render error_template_for(task_message), status: :unprocessable_entity
      end
    end
  end

  def handle_message_failure(alert:, fallback:)
    redirect_back fallback_location: fallback, alert: alert
  end

  def store_pending_message_and_redirect
    PendingTaskMessage.store(
      session,
      task_id: @task&.id,
      params: task_message_params,
      return_path: create_from_session_task_message_path(task_id: @task&.id)
    )
    redirect_to new_user_session_path and return
  end

  def success_turbo_streams
    [
      turbo_stream.update('task_messages', partial: 'tasks/show/questions', locals: { task: @task }),
      turbo_stream.update('modal', '')
    ]
  end

  def error_template_for(task_message)
    if task_message.reply?
      @parent_message = task_message.parent
      'modals/reply_task_message'
    else
      'modals/new_task_message'
    end
  end
end
