class SubmissionsController < ApplicationController
  before_action :authenticate_user!, except: %i[new create]
  before_action :set_task, only: %i[new create]
  before_action :set_submission, only: %i[show accept contact confirm_submission_accept]
  before_action :authorize_task_owner!, only: %i[accept confirm_submission_accept]

  def index
    @submissions = current_user.submissions.includes(:task)
  end

  def show; end

  def confirm_submission_accept
  render :confirm_submission_accept
  end

  def new
    @submission = @task.submissions.build
  end

  def create
    submission = SubmissionCreator.new(user: current_user, task: @task, params: submission_params).call
    if submission.persisted?
      redirect_to @task, notice: 'Pomyslnie złożono zgłoszenie do zadania.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def contact; end

  def accept
    @submission.accept!
    redirect_to contact_submission_path(@submission)
  rescue ActiveRecord::RecordInvalid => e
    redirect_back fallback_location: @submission.task, alert: e.message
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_submission
    @submission = Submission.find(params[:id])
  end

  def submission_params
    params.fetch(:submission, {}).permit(:note)
  end

  def authorize_task_owner!
    return if @submission.task.user == current_user

    redirect_back fallback_location: root_path,
                  alert: 'Tylko zleceniodawca może akceptować zlecenie'
  end
end
