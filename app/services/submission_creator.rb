class SubmissionCreator
  def initialize(user:, task:, params:)
    @user = user
    @task = task
    @params = params
  end

  def call
    submission = task.submissions.build(params)
    submission.user = user
    submission.save
    submission
  end

  private

  attr_reader :user, :task, :params
end
