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

  def self.create_for_user(user, session)
    payload = consume(session)&.deep_symbolize_keys
    task = Task.find_by(id: payload&.dig(:task_id))
    return unless payload && task

    TaskMessages::Creator.new(user: user, task: task, params: payload[:data] || {}).call
  end
end
