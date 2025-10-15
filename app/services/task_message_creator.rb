# frozen_string_literal: true

class TaskMessageCreator
  def initialize(user:, task:, params:)
    @user = user
    @task = task
    @params = params
  end

  def call
    task_message = @task.task_messages.new(@params.merge(user: @user))
    task_message.save
    task_message
  end
end
