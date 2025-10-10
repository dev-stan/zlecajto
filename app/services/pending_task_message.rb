# frozen_string_literal: true

class PendingTaskMessage
  SESSION_KEY = :pending_task_message
  RETURN_TO_KEY = :return_to

  def self.store(session, task_id:, params:, return_path: nil)
    session[SESSION_KEY] = { task_id: task_id, data: params.to_h }
    session[RETURN_TO_KEY] = return_path if return_path
  end

  def self.consume(session)
    session.delete(SESSION_KEY)
  end

  def self.present?(session)
    session[SESSION_KEY].present?
  end
end
