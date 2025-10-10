# frozen_string_literal: true

class TaskMessagesController < ApplicationController
  before_action :set_task
  before_action :authenticate_user!, except: %i[create create_from_session]

  def create
    # If not signed in, store draft in session and redirect to login
    unless user_signed_in?
      safe_attrs = if params[:task_message].is_a?(ActionController::Parameters)
                     params.require(:task_message).permit(:body, :parent_id, :message_type)
                   else
                     {}
                   end

      PendingTaskMessage.store(
        session,
        task_id: @task&.id,
        params: safe_attrs,
        return_path: create_from_session_task_message_path(task_id: @task&.id)
      )

      redirect_to new_user_session_path and return
    end

    @task_message = @task.task_messages.new(task_message_params.merge(user: current_user))

    # Authorization: anyone logged-in can ask a question;
    # replies allowed by: task owner OR original question author (thread root author)
    if @task_message.reply?
      root_author = (@task_message.parent&.thread_root || @task_message.parent)&.user
      allowed = (current_user == @task.user) || (current_user == root_author)
      unless allowed
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.update('modal', ''), status: :forbidden }
          format.html { redirect_to @task, alert: 'Tylko zleceniodawca lub autor pytania może odpowiadać.' }
        end
        return
      end
    end

    if @task_message.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('task_messages', partial: 'tasks/show/questions', locals: { task: @task }),
            turbo_stream.update('modal', '')
          ]
        end
        format.html { redirect_to @task, notice: 'Wiadomość została dodana.' }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          if @task_message.reply?
            @parent_message = @task_message.parent
            render 'modals/reply_task_message', status: :unprocessable_entity
          else
            render 'modals/new_task_message', status: :unprocessable_entity
          end
        end
        format.html do
          redirect_to @task, alert: "Nie udało się dodać wiadomości: #{@task_message.errors.full_messages.join(', ')}"
        end
      end
    end
  end

  def create_from_session
    # Only for logged in users
    authenticate_user!
    payload = PendingTaskMessage.consume(session)
    if payload.present?
      data = payload.deep_symbolize_keys
      task = Task.find_by(id: data[:task_id]) || @task
      redirect_back fallback_location: root_path, alert: 'Nie znaleziono zadania.' and return unless task

      attrs = (data[:data] || {}).slice(:body, :parent_id, :message_type)
      @task = task
      @task_message = @task.task_messages.new(attrs.merge(user: current_user))

      if @task_message.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update('task_messages', partial: 'tasks/show/questions', locals: { task: @task }),
              turbo_stream.update('modal', '')
            ]
          end
          format.html { redirect_to @task, notice: 'Wiadomość została dodana.' }
        end
      else
        respond_to do |format|
          format.turbo_stream { render 'modals/new_task_message', status: :unprocessable_entity }
          format.html do
            redirect_to @task, alert: "Nie udało się dodać wiadomości: #{@task_message.errors.full_messages.join(', ')}"
          end
        end
      end
    else
      redirect_back fallback_location: root_path, alert: 'Brak oczekującej wiadomości.'
    end
  end

  private

  def set_task
    task_id = params[:task_id] || params[:task]&.[](:id) || params[:id]
    @task = Task.find_by(id: task_id)
    @task ||= Task.find_by(id: params[:task_id]) if params[:task_id]
    # Fallback: when hitting top-level create_from_session without task_id, we'll resolve from session payload later
  end

  def task_message_params
    params.require(:task_message).permit(:body, :parent_id, :message_type)
  end
end
