# frozen_string_literal: true

class TasksController < ApplicationController
  # GET /my_tasks/:id
  def my_task
    @task = current_user.tasks.find(params[:id])
    # Add any additional logic here if needed
  end
  before_action :authenticate_user!, only: %i[new create wizard create_from_session edit_modal update my_task]
  before_action :load_wizard_collections, only: %i[new wizard create]

  def index
    @tasks = Task.with_attached_photos
  end

  def show
    @task = Task.find(params[:id])
    @existing_submission = current_user.submissions.find_by(task: @task) if user_signed_in?
  end

  def edit_modal
    @task = current_user.tasks.find(params[:id])
    render partial: 'tasks/edit_modal', locals: { task: @task }
  end

  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = t('tasks.flash.updated')
          render turbo_stream: [
            turbo_stream.replace('modal', '')
          ]
        end
        format.html { redirect_to my_task_path(@task), notice: t('tasks.flash.updated') }
      end
    else
      render partial: 'tasks/edit_modal', status: :unprocessable_entity, locals: { task: @task }
    end
  end

  # GET /tasks/new (step-driven wizard entry)
  def new
    init_wizard(advance: false)
  end

  # GET/POST /tasks/wizard (progress wizard via Turbo)
  def wizard
    init_wizard(advance: request.post?)
    render :new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to @task, notice: t('tasks.flash.created')
    else
      @wizard = TaskWizard.new(step: 2, params: task_params)
      @step   = @wizard.current_step
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
    data = session.delete(:pending_task_data)
    return unless data.present?

    @task = current_user.tasks.build(data)
    if @task.save
      redirect_to root_path, notice: t('tasks.flash.created_after_login')
    else
      redirect_to new_task_path(step: 2), alert: t('tasks.flash.creation_error')
    end
  end

  def task_params
    return {} unless params[:task]

    params.require(:task).permit(:title, :description, :salary, :status, :category, :due_date, :timeslot,
                                 :payment_method, :location, photos: [])
  end

  def load_wizard_collections
    @categories       = Task::CATEGORIES
    @time_slots       = Task::TIMESLOTS
    @payment_methods  = Task::PAYMENT_METHODS
    @locations = Task::LOCATIONS
  end

  def init_wizard(advance: false)
    @wizard = TaskWizard.new(step: params[:step], params: task_params, advance: advance)
    @task   = @wizard.task
    @step   = @wizard.current_step
  end
end
