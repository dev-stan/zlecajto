# frozen_string_literal: true

class TaskMessageCreator
  def initialize(user:, task:, params:)
    @user = user
    @task = task
    @params = params
  end

  def call
    # Force replies to attach to the latest message in thread
    if @params[:message_type].to_s == 'reply' && @params[:parent_id].present?
      requested_parent = @task.task_messages.find_by(id: @params[:parent_id])
      if requested_parent
        latest_parent = requested_parent.thread_latest_message
        @params = @params.merge(parent_id: latest_parent.id)
      end
    end

    task_message = @task.task_messages.new(@params.merge(user: @user))
    task_message.save
    task_message
  end
end
