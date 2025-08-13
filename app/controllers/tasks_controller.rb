class TasksController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new(wizard_params)
  end

  def create
    @task = Task.new(task_params)
    @task.user ||= current_user
    unless @task.user
      redirect_to tasks_path, alert: 'You must be signed in to create a task.' and return
    end
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task created.' }
        format.turbo_stream
      else
        Rails.logger.info('Task did not save to db')
  Rails.logger.debug { "Task errors: #{@task.errors.full_messages.join(', ')}" }
  format.html { render :new, status: :unprocessable_content }
  format.turbo_stream { render :new, status: :unprocessable_content }
      end
    end
  end

  def task_params
    params.require(:task).permit(:title, :description, :salary, :user_id, :status, :category)
  end

  def wizard_params
    return {} unless params[:task].present?
    # Use strong parameters to avoid ActiveModel::ForbiddenAttributesError when passing to Task.new
    if params[:task].is_a?(ActionController::Parameters)
      params.require(:task).permit(:category, :title)
    else
      params[:task].slice(:category, :title)
    end
  end
end