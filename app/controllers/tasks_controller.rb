# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!, only: %i[update edit my_task]
  before_action :set_task, only: %i[show edit update created completed]

  def my_task
    @task = current_user.tasks.find(params[:id])
  end

  def index
    @tasks = Task.with_attached_photos
  end

  def show; end

  def edit; end

  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def created; end

  def completed; end

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
