# frozen_string_literal: true

require 'test_helper'

class NotificationScopeTest < ActiveSupport::TestCase
  test 'unread_notifications_for_task? true only for related submissions' do
    user_owner = User.create!(email: 'owner@example.com', password: 'Password1!', first_name: 'Owner',
                              phone_number: '123456789')
    applicant = User.create!(email: 'applicant@example.com', password: 'Password1!', first_name: 'Applicant',
                             phone_number: '123456789')
    other_user = User.create!(email: 'other@example.com', password: 'Password1!', first_name: 'Other',
                              phone_number: '123456789')

    task = Task.create!(user: user_owner, title: 'Test task', status: 'Otwarte')
    submission = Submission.create!(task: task, user: applicant, status: :pending)

    # Notification for this submission (owner should see)
    notification = Notification.create!(user: user_owner, notifiable: submission, subject: 'new_submission')

    assert user_owner.unread_notifications_for_task?(task), 'Owner should have unread notification for task'
    assert_not other_user.unread_notifications_for_task?(task), 'Unrelated user should not have unread notification'

    notification.mark_as_read!
    assert_not user_owner.unread_notifications_for_task?(task), 'Owner should not after marking as read'
  end
end
