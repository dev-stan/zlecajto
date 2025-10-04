# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!, only: %i[update edit my_task]
  before_action :set_task, only: %i[show edit update created completed destroy completed]

  def show
    return unless current_user

    current_user&.notifications&.unread&.for_task(@task)&.first&.mark_as_read!
  end

  def edit; end

  def destroy
    @task.destroy
    redirect_to profile_path, notice: 'Usunięto zlecenie.'
  end

  def created; end

  def completed
    @task.complete!
  end

  def my_task
    @task = current_user.tasks.find(params[:id])
    # [todo] this looks like shit, refactor me
    current_user.notifications.unread.for_task(@task).first&.mark_as_read!
  end

  def index
    @tasks = Task.with_attached_photos.where.not(status: :accepted)
  end

  def update
    # [todo] i already set a task here, do i need to find it again?
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      # Redirect owner to the dedicated "my task" view after updating via modal
      redirect_to my_task_path(@task), notice: 'Task was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    return {} unless params[:task]

    params.require(:task).permit(:title, :description, :salary, :status, :category, :due_date, :timeslot,
                                 :payment_method, :location, photos: [], photo_blob_ids: [])
  end
end
