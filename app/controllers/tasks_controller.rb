# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!, only: %i[update edit my_task]
  before_action :set_task, only: %i[show edit update created completed]

  def show
    current_user.notifications.unread.for_task(@task).first&.mark_as_read!
  end
  def edit; end
  
  def created; end
  def completed; end


  def my_task
    @task = current_user.tasks.find(params[:id])
    # [todo] this looks like shit, refactor me
    current_user.notifications.unread.for_task(@task).first&.mark_as_read!
  end

  def index
    @tasks = Task.with_attached_photos
  end

  def update
    # [todo] i already set a task here, do i need to find it again?
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
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
