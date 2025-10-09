# frozen_string_literal: true

class AddPhoneNumberToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :phone_number, :string, null: false, default: ''
  end
end
