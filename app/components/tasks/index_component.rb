class Tasks::IndexComponent < ViewComponent::Base
  def initialize(task_array: nil, current_user: nil)
    @task_array = task_array
    @current_user = current_user
  end
end
