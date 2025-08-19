# frozen_string_literal: true

class RenameDueAtToDueDateInTasks < ActiveRecord::Migration[7.1]
  def change
    rename_column :tasks, :due_at, :due_date
  end
end
