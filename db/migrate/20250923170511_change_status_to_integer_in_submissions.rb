# frozen_string_literal: true

class ChangeStatusToIntegerInSubmissions < ActiveRecord::Migration[7.1]
  def change
    remove_column :submissions, :status
    add_column :submissions, :status, :integer, default: 0
  end
end
