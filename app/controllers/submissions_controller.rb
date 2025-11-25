# frozen_string_literal: true

class SubmissionsController < ApplicationController
  before_action :authenticate_user!, except: %i[new create]
  before_action :set_task, only: %i[new create]
  before_action :set_submission,
                only: %i[show accept accepted confirm_submission_accept cancell_chosen]
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

  def cancell_chosen
    Submissions::CancellChosenService.new(@submission).call
    redirect_to my_task_path(@submission.task), notice: 'Teraz możesz wybrać innego wykonawcę.'
  end

  def create
    unless user_signed_in?
      PendingSubmission.store(session, params: submission_params, task_id: @task.id,
                                       return_path: create_from_session_submission_path)
      redirect_to new_user_session_path and return
    end

    if @task.user_id == current_user.id
      redirect_back fallback_location: @task, alert: 'Nie możesz zgłosić się do własnego zadania' and return
    end

    submission = Submissions::Creator.new(user: current_user, task: @task, params: submission_params).call

    if submission.persisted?
      redirect_to @task, notice: 'Pomyslnie złożono zgłoszenie do zadania.'
    else
      @submission = submission
      render :new, status: :unprocessable_entity
    end
  end

  def create_from_session
    submission = PendingSubmission.create_for_user(current_user, session)

    if submission&.persisted?
      redirect_to submission.task, notice: 'Pomyslnie złożono zgłoszenie do zadania.'
    else
      redirect_back fallback_location: root_path, alert: 'Coś poszło nie tak, spróbuj ponownie...'
    end
  end

  def accepted; end

  def accept
    Submissions::AcceptService.new(@submission).call
<<<<<<< HEAD
    @conversation = Conversation.find_by(submission_id: @submission.id)
    redirect_to conversation_path(@conversation)
=======
    redirect_to conversation_path(@submission.conversation)
>>>>>>> 6220422 (changes)
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
