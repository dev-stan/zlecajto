# frozen_string_literal: true

class AddLocationToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :location, :string
  end
end
