class RemoveRestrictiveConversationIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :conversations, name: "index_conversations_on_submission_owner_id_and_task_owner_id"
  end
end