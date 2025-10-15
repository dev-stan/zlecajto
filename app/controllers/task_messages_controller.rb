# frozen_string_literal: true

class TaskMessagesController < ApplicationController
  before_action :set_task
  before_action :authenticate_user!, except: %i[create create_from_session]
  before_action :set_task_message, only: %i[], if: -> { false } # Placeholder for consistency
  before_action :authorize_reply!, only: %i[create], if: -> { @task_message&.reply? }

  def create
    unless user_signed_in?
      store_pending_message_and_redirect
      return
    end

    @task_message = @task.task_messages.new(task_message_params.merge(user: current_user))

    respond_to do |format|
      if @task_message.save
        format.turbo_stream { render turbo_stream: success_turbo_streams }
        format.html { redirect_to @task, notice: 'Wiadomość została dodana.' }
      else
        format.turbo_stream { render error_template, status: :unprocessable_entity }
        format.html do
          redirect_to @task, alert: "Nie udało się dodać wiadomości: #{@task_message.errors.full_messages.join(', ')}"
        end
      end
    end
  end

  def create_from_session
    @task_message = PendingTaskMessage.create_for_user(current_user, session)

    if @task_message&.persisted?
      @task = @task_message.task
      respond_to do |format|
        format.turbo_stream { render turbo_stream: success_turbo_streams }
        format.html { redirect_to @task, notice: 'Wiadomość została dodana.' }
      end
    else
      redirect_back fallback_location: root_path, alert: 'Coś poszło nie tak, spróbuj ponownie...'
    end
  end

  private

  def set_task
    @task = Task.find_by(id: task_id)
  end

  def task_message_params
    params.require(:task_message).permit(:body, :parent_id, :message_type)
  end

  def store_pending_message_and_redirect
    PendingTaskMessage.store(
      session,
      task_id: @task&.id,
      params: task_message_params,
      return_path: create_from_session_task_message_path(task_id: @task&.id)
    )

    redirect_to new_user_session_path
  end

  def authorize_reply!
    root_author = (@task_message.parent&.thread_root || @task_message.parent)&.user
    allowed = current_user == @task.user || current_user == root_author

    return if allowed

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update('modal', ''), status: :forbidden }
      format.html { redirect_to @task, alert: 'Tylko zleceniodawca lub autor pytania może odpowiadać.' }
    end
  end

  def success_turbo_streams
    [
      turbo_stream.update('task_messages', partial: 'tasks/show/questions', locals: { task: @task }),
      turbo_stream.update('modal', '')
    ]
  end

  def error_template
    if @task_message.reply?
      @parent_message = @task_message.parent
      'modals/reply_task_message'
    else
      'modals/new_task_message'
    end
  end
end
