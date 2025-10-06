class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = Answer.new(answer_params)
    @answer.user = current_user
    @submission = Submission.find(@answer.submission_id)

    unless current_user.id == @submission.user_id || current_user.id == @submission.task.user_id
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update('modal', ''), status: :forbidden }
        format.html do
          redirect_back fallback_location: @submission.task, alert: 'Tylko zleceniodawca może odpowiadać na zgłoszenie'
        end
      end
      return
    end

    if @answer.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("answers_#{@submission.id}",
                                partial: 'tasks/show/answers',
                                locals: { submission: @submission }),
            turbo_stream.update('modal', '')
          ]
        end
        format.html { redirect_back fallback_location: @submission.task, notice: 'Odpowiedź wysłana.' }
      end
    else
      respond_to do |format|
        format.turbo_stream { render 'modals/new_answer', status: :unprocessable_entity }
        format.html { redirect_back fallback_location: @submission.task, alert: 'Nie udało się wysłać odpowiedzi.' }
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:message, :submission_id)
  end
end
