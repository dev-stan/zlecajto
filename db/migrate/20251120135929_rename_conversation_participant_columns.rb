class RenameConversationParticipantColumns < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :conversations, column: :sender_id
    remove_foreign_key :conversations, column: :recipient_id

    rename_column :conversations, :sender_id, :submission_owner_id
    rename_column :conversations, :recipient_id, :task_owner_id

    rename_column :conversations, :sender_last_seen_at, :submission_owner_last_seen_at
    rename_column :conversations, :recipient_last_seen_at, :task_owner_last_seen_at

    add_foreign_key :conversations, :users, column: :submission_owner_id
    add_foreign_key :conversations, :users, column: :task_owner_id
  end
end
