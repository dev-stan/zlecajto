require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factories' do
    it 'has a valid factory' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  describe 'validations' do
    it 'requires a first_name' do
      user = build(:user, first_name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to be_present
    end

    it 'requires an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it 'requires phone_number for non-google users' do
      user = build(:user, phone_number: nil, provider: nil, uid: nil)
      expect(user).not_to be_valid
      expect(user.errors[:phone_number]).to be_present
    end

    it 'does not require phone_number for google oauth users' do
      user = build(:user, phone_number: nil, provider: 'google_oauth2', uid: '12345')
      expect(user).to be_valid
    end
  end

  describe 'associations' do
    it 'can have many tasks' do
      user = create(:user)
      create_list(:task, 2, user: user)
      expect(user.tasks.size).to eq(2)
    end

    it 'can have many submissions' do
      allow_any_instance_of(Submission).to receive(:send_new_submission_email)
      allow_any_instance_of(Submission).to receive(:create_new_submission_notification)

      user = create(:user)
      task1 = create(:task)
      task2 = create(:task)

      create(:submission, user: user, task: task1)
      create(:submission, user: user, task: task2)

      expect(user.submissions.size).to eq(2)
    end
  end

  describe '#display_name' do
    it 'returns first name and initial of last name' do
      user = build(:user, first_name: 'Marta', last_name: 'Skubis')
      expect(user.display_name).to eq('Marta S')
    end

    it 'returns only first name when last name is blank' do
      user = build(:user, first_name: 'Marta', last_name: nil)
      expect(user.display_name).to eq('Marta ')
    end
  end

  describe '#unread_notifications_count' do
    it 'delegates to notifications.unread.count' do
      user = build(:user)
      notifications_assoc = double('notifications')
      unread_scope = double('unread_scope')

      allow(user).to receive(:notifications).and_return(notifications_assoc)
      allow(notifications_assoc).to receive(:unread).and_return(unread_scope)
      allow(unread_scope).to receive(:count).and_return(5)

      expect(user.unread_notifications_count).to eq(5)
    end
  end

  describe '#unread_notifications_for_task?' do
    it 'delegates to notifications.unread.for_task(task).exists?' do
      user = build(:user)
      task = build(:task)

      notifications_assoc = double('notifications')
      unread_scope = double('unread_scope')
      task_scope = double('task_scope')

      allow(user).to receive(:notifications).and_return(notifications_assoc)
      allow(notifications_assoc).to receive(:unread).and_return(unread_scope)
      allow(unread_scope).to receive(:for_task).with(task).and_return(task_scope)
      allow(task_scope).to receive(:exists?).and_return(true)

      expect(user.unread_notifications_for_task?(task)).to be true
    end
  end

  describe '#remember_me' do
    it 'always returns true' do
      user = build(:user)
      expect(user.remember_me).to be true
    end
  end

  describe 'callbacks' do
    it 'enqueues welcome email after create' do
      user = build(:user)
      allow(MailgunTemplateJob).to receive(:perform_later)

      user.save!

      expect(MailgunTemplateJob).to have_received(:perform_later).with(
        hash_including(
          to: user.email,
          template: 'prod_welcome_email',
          subject: 'Witaj w zlecajto :)'
        )
      )
    end
  end

  describe 'ransack allowlists' do
    it 'includes expected attributes' do
      attrs = User.ransackable_attributes
      %w[email first_name last_name phone_number provider uid verified].each do |attr|
        expect(attrs).to include(attr)
      end
    end
  end

  describe '#phone_number' do
    it 'normalizes "123456789" to "+48123456789"' do
      user = build(:user, phone_number: '123456789')
      expect(user.phone_number).to eq('+48123456789')
    end

    it 'normalizes "+48 123456789" to "+48123456789"' do
      user = build(:user, phone_number: '+48 123456789')
      expect(user.phone_number).to eq('+48123456789')
    end

    it 'normalizes "+48123456789" to "+48123456789"' do
      user = build(:user, phone_number: '+48123456789')
      expect(user.phone_number).to eq('+48123456789')
    end

    it 'normalizes "0123456789" to "+48123456789"' do
      user = build(:user, phone_number: '0123456789')
      expect(user.phone_number).to eq('+48123456789')
    end
  end
end
