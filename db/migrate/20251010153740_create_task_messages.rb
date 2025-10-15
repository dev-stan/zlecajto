# frozen_string_literal: true

class CreateTaskMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :task_messages do |t|
      t.references :task, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :parent, foreign_key: { to_table: :task_messages } # self-referential
      t.text :body, null: false
      t.integer :message_type, default: 0, null: false

      t.timestamps
    end

    # Indexes for faster queries
    add_index :task_messages, %i[task_id parent_id]
  end
end
