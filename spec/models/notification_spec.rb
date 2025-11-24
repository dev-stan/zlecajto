require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'factories' do
    it 'has a valid factory' do
      notification = build(:notification)
      expect(notification).to be_valid
    end
  end

  describe 'scopes' do
    describe '.unread' do
      it 'returns notifications with nil read_at' do
        unread = create(:notification, read_at: nil)
        read = create(:notification, read_at: Time.current)

        expect(Notification.unread).to include(unread)
        expect(Notification.unread).not_to include(read)
      end
    end

    describe '.for_task' do
      it 'returns none when task is nil' do
        expect(Notification.for_task(nil)).to be_empty
      end

      it 'returns notifications for submissions belonging to the task' do
        task = create(:task)
        other_task = create(:task)
        user = create(:user)

        allow_any_instance_of(Submission).to receive(:send_new_submission_email)
        allow_any_instance_of(Submission).to receive(:create_new_submission_notification)

        submission_for_task = create(:submission, task: task, user: user)
        submission_for_other = create(:submission, task: other_task, user: user)

        note1 = create(:notification, user: user, notifiable: submission_for_task)
        note2 = create(:notification, user: user, notifiable: submission_for_other)

        result = Notification.for_task(task)
        expect(result).to include(note1)
        expect(result).not_to include(note2)
      end
    end
  end

  describe '#seen?' do
    it 'is true when read_at is present' do
      notification = build(:notification, read_at: Time.current)
      expect(notification.seen?).to be true
    end

    it 'is false when read_at is nil' do
      notification = build(:notification, read_at: nil)
      expect(notification.seen?).to be false
    end
  end

  describe '#mark_as_read!' do
    it 'sets read_at when currently nil' do
      notification = create(:notification, read_at: nil)
      expect { notification.mark_as_read! }.to change(notification, :read_at).from(nil)
    end

    it 'does nothing when already read' do
      time = Time.current
      notification = create(:notification, read_at: time)
      expect { notification.mark_as_read! }.not_to change(notification, :read_at)
    end
  end

  describe 'ransack allowlists' do
    it 'returns expected attributes' do
      expected = %w[id user_id subject read_at notifiable_type notifiable_id created_at updated_at]
      expect(Notification.ransackable_attributes).to include(*expected)
    end

    it 'returns expected associations' do
      expected = %w[user notifiable]
      expect(Notification.ransackable_associations).to match_array(expected)
    end
  end
end
