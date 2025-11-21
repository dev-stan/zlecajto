class AddLastSeenColumnsToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :sender_last_seen_at, :datetime
    add_column :conversations, :recipient_last_seen_at, :datetime
    add_index  :conversations, :sender_last_seen_at
    add_index  :conversations, :recipient_last_seen_at
  end
end
