# frozen_string_literal: true

module LoginRedirect
  extend ActiveSupport::Concern

  private

  def pending_redirect_path
    # 1. Prefer explicit return path set by the initiating flow
    if session[:return_to].present?
      return_path = session.delete(:return_to)
      return return_path
    end

    # 2. Fall back to pending flow flags
    if PendingSubmission.present?(session)
      create_from_session_submission_path
    elsif PendingTaskMessage.present?(session)
      create_from_session_task_message_path
    elsif PendingTask.present?(session)
      create_from_session_task_path
    end
  end
end
