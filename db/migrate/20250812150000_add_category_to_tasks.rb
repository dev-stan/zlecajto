# frozen_string_literal: true

class AddCategoryToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :category, :string
    add_index :tasks, :category
  end
end
