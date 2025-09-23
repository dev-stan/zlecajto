class PendingTask
  SESSION_KEY = :pending_task_data
  RETURN_TO_KEY = :return_to

  def self.store(session, params:, return_path: nil)
    session[SESSION_KEY] = params.to_h
    session[RETURN_TO_KEY] = return_path if return_path
  end

  def self.consume(session)
    session.delete(SESSION_KEY)
  end

  def self.present?(session)
    session[SESSION_KEY].present?
  end

  def self.create_for_user(user, session)
    data = consume(session)
    return nil unless data.present?

    # Ensure symbolized keys for strong params-like access
    data = data.deep_symbolize_keys
    TaskCreator.new(user: user, params: data).call
  end
end
