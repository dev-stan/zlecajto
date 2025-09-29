class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: true
      t.string :subject, null: false
      t.datetime :read_at, null: true
      t.timestamps
    end

    add_index :notifications, [:user_id, :read_at]
  end
end