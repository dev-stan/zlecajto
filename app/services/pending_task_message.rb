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
    payload = consume(session)
    return nil unless payload.present?

    data = payload.deep_symbolize_keys
    task = Task.find_by(id: data[:task_id])
    return nil unless task

    attrs = (data[:data] || {}).slice(:body, :parent_id, :message_type)
    task_message = task.task_messages.new(attrs.merge(user: user))
    task_message.save
    task_message
  end
end
