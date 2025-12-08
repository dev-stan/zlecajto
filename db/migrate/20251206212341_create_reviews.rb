class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :task, null: false, foreign_key: true

      t.references :author,    null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }

      t.text    :description
      t.integer :rating

      t.timestamps
    end

    add_index :reviews,
              [:task_id, :author_id, :recipient_id],
              unique: true,
              name: "index_reviews_on_task_and_users"
  end
end
