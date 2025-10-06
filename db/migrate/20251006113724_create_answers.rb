# db/migrate/20251006130500_create_answers.rb
class CreateAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.string :message
      t.references :user, null: false, foreign_key: true
      t.references :submission, null: false, foreign_key: true

      t.timestamps
    end
  end
end
