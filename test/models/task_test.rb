# frozen_string_literal: true

require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test 'responds to photos' do
    task = Task.new(title: 't', description: 'd', category: Task::CATEGORIES.first,
                    user: User.new(email: 'x@example.com', password: 'password123'))
    assert_respond_to task, :photos
  end
end
