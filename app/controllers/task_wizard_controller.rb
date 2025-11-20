# frozen_string_literal: true

class TaskWizardController < ApplicationController
  # Allow unauthenticated users to hit `create` so we can stash the task in session.
  before_action :authenticate_user!, only: %i[create_from_session]
  before_action :load_wizard_collections, only: %i[new wizard create]

  def new
    init_wizard(advance: false)
  end

  # this action advances the wizard / called with form in views
  def wizard
    init_wizard(advance: request.post?)
    render :new
  end

  def create
    unless user_signed_in?
      PendingTask.store(session, params: task_params, return_path: create_from_session_task_path)
      redirect_to new_user_session_path
      return
    end

    task = Tasks::Creator.new(user: current_user, params: task_params).call

    if task.persisted?
      redirect_to created_task_path(task)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_from_session
    task = PendingTask.create_for_user(current_user, session)

    if task&.persisted?
      redirect_to task_path(task), notice: 'Dodano zlecenie 🚀'
    else
      redirect_to new_task_path(step: 2), alert: 'Coś poszło nie tak, spróbuj ponownie...'
    end
  end

  private

  def task_params
    return {} unless params[:task]

    params.require(:task).permit(:title, :description, :salary, :status, :category, :due_date, :due_date_any, :timeslot,
                                 :payment_method, :location, photos: [], photo_blob_ids: [])
  end

  def load_wizard_collections
    @categories = Task::CATEGORIES
    @time_slots = Task::TIMESLOTS
    @payment_methods = Task::PAYMENT_METHODS
    @locations = Task::LOCATIONS
  end

  def init_wizard(advance: false)
    @wizard = TaskWizard.new(step: params[:step], params: task_params, advance: advance)
    @task = @wizard.task
    @step = @wizard.current_step
  end
end
