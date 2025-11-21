# frozen_string_literal: true

class NormalizeAcceptedStatusOnTasks < ActiveRecord::Migration[7.1]
  def up
    execute <<~SQL
      UPDATE tasks
      SET status = 'Wybrano wykonawcę'
      WHERE status = 'accepted';
    SQL
  end

  def down
    # NOTE: This reverts any 'accepted' status back to the old Polish label.
    execute <<~SQL
      UPDATE tasks
      SET status = 'accepted'
      WHERE status = 'Wybrano wykonawcę';
    SQL
  end
end
