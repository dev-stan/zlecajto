class AddSuperpowersToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :superpowers, :string, array: true, default: [], null: false
  end
end
