class AddNoteToSubmissions < ActiveRecord::Migration[7.1]
  def change
    add_column :submissions, :note, :string
  end
end
