# frozen_string_literal: true

class AddTimeslotToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :timeslot, :string
  end
end
