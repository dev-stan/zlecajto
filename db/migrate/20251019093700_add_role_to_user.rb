class AddRoleToUser < ActiveRecord::Migration[7.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :role
    end
  end
end
