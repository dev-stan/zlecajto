class ChangeCategoryToCategoriesInUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users, bulk: true do |t|
      t.remove :category
      t.string :categories, array: true, default: []
    end
  end
end
