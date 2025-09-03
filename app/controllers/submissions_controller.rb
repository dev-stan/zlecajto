# frozen_string_literal: true

class SubmissionsController < ApplicationController
  # Allow guests to open the new submission form; require auth only when persisting or managing.
  before_action :authenticate_user!, except: %i[new]
  before_action :set_task, only: %i[new create]
  before_action :set_submission, only: %i[show edit update destroy accept reject]
  before_action :authorize_task_owner!, only: %i[accept reject]

  def index
    @submissions = current_user.submissions.includes(:task)
  end

  def show; end

  def new
    if user_signed_in?
      existing_submission = current_user.submissions.find_by(task: @task)
      if existing_submission
        redirect_to @task, alert: t('submissions.flash.already_applied') and return
      end
    end
    @submission = @task.submissions.build # Unsaved; fields can be prefilled later
  end

  def create
    unless user_signed_in?
      session[:pending_submission_data] = submission_params
      session[:pending_submission_task_id] = @task.id
      session[:return_to] = create_from_session_submissions_path
      redirect_to new_user_session_path and return
    end

    existing_submission = current_user.submissions.find_by(task: @task)
    if existing_submission
      redirect_to @task, alert: t('submissions.flash.already_applied') and return
    end

    persist_submission(submission_params)
  end

  def edit; end

  def update
    if @submission.update(submission_params)
      redirect_to @submission, notice: 'Aplikacja została zaktualizowana'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @submission.destroy
    redirect_to submissions_path, notice: 'Aplikacja została usunięta'
  end

  def accept
    if @submission.update(status: 'accepted')
      redirect_back fallback_location: @submission.task, notice: I18n.t('submissions.flash.accepted')
    else
      redirect_back fallback_location: @submission.task, alert: @submission.errors.full_messages.to_sentence
    end
  end

  def reject
    if @submission.update(status: 'rejected')
      redirect_back fallback_location: @submission.task, notice: I18n.t('submissions.flash.rejected')
    else
      redirect_back fallback_location: @submission.task, alert: @submission.errors.full_messages.to_sentence
    end
  end

  # Finalize a deferred submission after authentication
  def create_from_session
    data = session.delete(:pending_submission_data)
    task_id = session.delete(:pending_submission_task_id)
    unless data && task_id
      redirect_to tasks_path, alert: t('submissions.flash.creation_error') and return
    end

    @task = Task.find_by(id: task_id)
    unless @task
      redirect_to tasks_path, alert: t('submissions.flash.creation_error') and return
    end

    existing_submission = current_user.submissions.find_by(task: @task)
    if existing_submission
      redirect_to @task, alert: t('submissions.flash.already_applied') and return
    end

    persist_submission(data)
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_submission
    # For owner moderation allow finding among task submissions
    @submission = Submission.find(params[:id])
  end

  def submission_params
    # Currently only status is available in the schema
    # In a real app, you might want to add fields like message, proposed_price
    # Use fetch instead of require so submitting an empty form (no fields) won't raise.
    params.fetch(:submission, {}).permit(:status, :note)
  end

  def authorize_task_owner!
    return if @submission.task.user_id == current_user.id

    redirect_back fallback_location: root_path, alert: I18n.t('unauthorized')
  end

  def persist_submission(data)
    @submission = @task.submissions.build(data)
    @submission.user = current_user
    if @submission.save
      redirect_to @task, notice: t('submissions.flash.created')
    else
      render :new, status: :unprocessable_entity
    end
  end
end
