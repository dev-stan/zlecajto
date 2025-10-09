# frozen_string_literal: true

class AddDefaultToTaskStatus < ActiveRecord::Migration[7.1]
  def change
    change_column_default :tasks, :status, 'Otwarte'
  end
end
