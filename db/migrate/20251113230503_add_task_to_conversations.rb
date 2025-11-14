class AddTaskToConversations < ActiveRecord::Migration[7.1]
  def change
    add_reference :conversations, :task, null: false, foreign_key: true
  end
end
