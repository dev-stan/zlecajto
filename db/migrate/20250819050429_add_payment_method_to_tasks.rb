# frozen_string_literal: true

class AddPaymentMethodToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :payment_method, :string
  end
end
