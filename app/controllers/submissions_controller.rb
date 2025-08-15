# frozen_string_literal: true

class SubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[new create]
  before_action :set_submission, only: %i[show edit update destroy]

  def index
    @submissions = current_user.submissions.includes(:task)
  end

  def show; end

  def new
    # Check if user has already applied to this task
    existing_submission = current_user.submissions.find_by(task: @task)
    if existing_submission
      redirect_to @task, alert: 'Już aplikowałeś na to zadanie'
      return
    end

    @submission = @task.submissions.build
  end

  def create
    # Check if user has already applied to this task
    existing_submission = current_user.submissions.find_by(task: @task)
    if existing_submission
      redirect_to @task, alert: 'Już aplikowałeś na to zadanie'
      return
    end

    @submission = @task.submissions.build(submission_params)
    @submission.user = current_user

    if @submission.save
      redirect_to @task, notice: 'Pomyślnie aplikowałeś na zadanie!'
    else
      render :new, status: :unprocessable_entity
    end
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

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_submission
    @submission = current_user.submissions.find(params[:id])
  end

  def submission_params
    # Currently only status is available in the schema
    # In a real app, you might want to add fields like message, proposed_price
    params.require(:submission).permit(:status)
  end
end
