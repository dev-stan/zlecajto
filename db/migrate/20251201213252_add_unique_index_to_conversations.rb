class AddUniqueIndexToConversations < ActiveRecord::Migration[7.1]
  def change
    add_index :conversations, 
              [:submission_owner_id, :task_owner_id, :task_id, :submission_id], 
              unique: true, 
              name: "index_unique_conversations"
  end
end
