class Tasks::IndexComponent < ViewComponent::Base
  def initialize(task_array: nil, current_user: nil, show_notification: false)
    @task_array = task_array
    @current_user = current_user
    @show_notification = show_notification
  end
end
