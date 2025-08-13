class TasksController < ApplicationController
  before_action :authenticate_user!, only: %i[create create_from_session]

  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @step = params[:step].presence&.to_i || 1
    @task = Task.new(wizard_params)
    @categories = Task::CATEGORIES
  end

  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      redirect_to root_path, notice: 'Pomyślnie utworzono zadanie'
    else
      @step = 2
      @categories = Task::CATEGORIES
      render :new, status: :unprocessable_entity
    end
  end

  def authenticate_and_create
    # Store task data in session before redirecting to authentication
    if params[:task].present?
      Rails.logger.debug "Storing task data: #{params[:task].inspect}"
      session[:pending_task_data] = task_params
      session[:return_to] = create_from_session_tasks_path # Use dedicated route after login
      Rails.logger.debug "Session data stored: #{session[:pending_task_data].inspect}"
    end
    
    redirect_to new_user_session_path
  end
  
  def create_from_session
    create_pending_task
    # If no pending task or creation failed, redirect to index
    redirect_to tasks_path unless performed?
  end

  private

  def create_pending_task
    return unless session[:pending_task_data].present?
    
    Rails.logger.debug "Creating pending task with data: #{session[:pending_task_data].inspect}"
    @task = current_user.tasks.build(session[:pending_task_data])
    
    if @task.save
      Rails.logger.debug "Task created successfully: #{@task.inspect}"
      session.delete(:pending_task_data)
      redirect_to root_path, notice: 'Pomyślnie utworzono zadanie i zalogowano!'
      return
    else
      Rails.logger.debug "Task creation failed: #{@task.errors.full_messages.inspect}"
      # If task creation fails, redirect to form with errors
      session.delete(:pending_task_data) # Clean up bad data
      redirect_to new_task_path(step: 2), alert: 'Wystąpił problem z utworzeniem zadania. Spróbuj ponownie.'
      return
    end
  end

  def task_params
    return {} unless params[:task].present?
    params.require(:task).permit(:title, :description, :salary, :status, :category)
  end

  def wizard_params
    return {} unless params[:task].present?
    params[:task].permit(:category, :title, :description, :salary)
  end
end