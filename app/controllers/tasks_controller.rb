# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!, only: %i[create create_from_session]

  def index
    @tasks = Task.with_attached_photos
  end

  def show
    @task = Task.find(params[:id])
    @existing_submission = current_user.submissions.find_by(task: @task) if user_signed_in?
  end

  # POST /tasks/wizard progresses from step 1 -> 2 while retaining entered fields
  def wizard
    @task = Task.new(wizard_params)

    @categories = Task::CATEGORIES
    @time_slots = Task::TIMESLOTS
    @payment_methods = Task::PAYMENT_METHODS

    current_step = (params[:step] || 1).to_i

    @task.due_date = params.dig(:task, :due_date)
    @task.timeslot = params.dig(:task, :timeslot)

    @step = if request.post?
              [current_step + 1, 4].min
            else
              current_step
            end

    render :new
  end

  def new
    @step = params[:step].presence&.to_i || 1
    @task = Task.new(wizard_params)
    @task.due_date = params.dig(:task, :due_date)
    @task.timeslot = params.dig(:task, :timeslot)
    @categories = Task::CATEGORIES
    @time_slots = Task::TIMESLOTS
    @payment_methods = Task::PAYMENT_METHODS
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to root_path, notice: 'Pomyślnie utworzono zadanie'
    else
      @step = 2
      @categories = Task::CATEGORIES
      @time_slots = Task::TIMESLOTS
      @payment_methods = Task::PAYMENT_METHODS
      render :new, status: :unprocessable_entity
    end
  end

  def authenticate_and_create
    if params[:task].present?
      session[:pending_task_data] = task_params
      session[:return_to] = create_from_session_tasks_path # Use dedicated route after login
    end

    redirect_to new_user_session_path
  end

  def create_from_session
    create_pending_task
    redirect_to tasks_path unless performed?
  end

  private

  def create_pending_task
    return unless session[:pending_task_data].present?

    @task = current_user.tasks.build(session[:pending_task_data])

    if @task.save
      redirect_to root_path, notice: 'Pomyślnie utworzono zadanie i zalogowano!'
    else
      redirect_to new_task_path(step: 2), alert: 'Wystąpił problem z utworzeniem zadania. Spróbuj ponownie.'
    end
    session.delete(:pending_task_data)
    nil
  end

  def task_params
    return {} unless params[:task].present?

    params.require(:task).permit(:title, :description, :salary, :status, :category, :due_date, :timeslot, :payment_method,
                                 photos: [])
  end

  def wizard_params
    return {} unless params[:task].present?

    params[:task].permit(:category, :title, :description, :salary, :due_date, :timeslot, :payment_method)
  end
end
