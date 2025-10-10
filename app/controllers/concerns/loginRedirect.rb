# frozen_string_literal: true

module LoginRedirect
  extend ActiveSupport::Concern

  private

  def pending_redirect_path
    if PendingSubmission.present?(session)
      create_from_session_submissions_path
    elsif PendingTaskMessage.present?(session)
      create_from_session_task_message_path
    elsif PendingTask.present?(session)
      create_from_session_task_path
    elsif session[:return_to].present?
      return_path = session[:return_to]
      session.delete(:return_to)
      return_path
    end
  end
end
