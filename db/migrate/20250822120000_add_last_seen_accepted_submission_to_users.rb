# frozen_string_literal: true

class AddLastSeenAcceptedSubmissionToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :last_seen_accepted_submission_at, :datetime
    add_index :users, :last_seen_accepted_submission_at
  end
end
