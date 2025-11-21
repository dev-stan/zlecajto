class AddSubmissionIdToConversations < ActiveRecord::Migration[7.1]
  def change
    add_reference :conversations, :submission, null: false, foreign_key: true
  end
end
