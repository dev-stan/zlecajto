# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.decimal :salary
      t.string :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
