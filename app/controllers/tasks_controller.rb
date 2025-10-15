# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!, only: %i[update edit my_task]
  before_action :set_task, only: %i[show edit update created completed my_task destroy completed]

  def show
    @presenter = TaskShowPresenter.new(@task, current_user)
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
    @presenter = TaskShowPresenter.new(@task, current_user)
    # [todo] this looks like shit, refactor me
    current_user.notifications.unread.for_task(@task).first&.mark_as_read!
  end

  def index
    @tasks = Task.order(created_at: :desc)
                 .with_attached_photos
                 .where.not(status: %i[accepted completed])
    @completed_tasks = Task
                       .order(created_at: :desc)
                       .with_attached_photos
                       .where(status: :completed)
                       .where.not(id: 159)
  end

  def update
    if @task.update(task_params)
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
