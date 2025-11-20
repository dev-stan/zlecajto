class ChangeDefaultStatusForTasks < ActiveRecord::Migration[7.1]
  def change
    change_column_default :tasks, :status, from: 'Otwarte', to: 'open'
  end
end
