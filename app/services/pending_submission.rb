class PendingSubmission
  SESSION_KEY = :pending_submission

  def self.store(session, task_id:, params:)
    session[SESSION_KEY] = { task_id: task_id, data: params.to_h }
  end

  def self.consume(session)
    session.delete(SESSION_KEY)
  end

  def self.present?(session)
    session[SESSION_KEY].present?
  end
end
