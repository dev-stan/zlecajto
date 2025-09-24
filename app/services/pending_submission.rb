class PendingSubmission
  SESSION_KEY = :pending_submission
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

  # Ensure symbolized keys for strong params-like access
  payload = payload.deep_symbolize_keys
  task_id = payload[:task_id]
  submission_attrs = payload[:data] || {}

  return nil if task_id.blank?

  task = Task.find_by(id: task_id)
  return nil unless task

  SubmissionCreator.new(user: user, task: task, params: submission_attrs).call
  end
end
