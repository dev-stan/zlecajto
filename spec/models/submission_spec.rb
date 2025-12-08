require 'rails_helper'

RSpec.describe Submission, type: :model do
  describe 'factories' do
    it 'has a valid factory' do
      allow_any_instance_of(Submission).to receive(:send_new_submission_email)
      allow_any_instance_of(Submission).to receive(:create_new_submission_notification)

      submission = build(:submission, user: create(:user), task: create(:task))

      expect(submission).to be_valid
    end
  end

  describe 'validations' do
    it 'requires a status' do
      submission = build(:submission, status: nil)
      expect(submission).not_to be_valid
      expect(submission.errors[:status]).to be_present
    end

    it 'does not allow applying to own task' do
      user = create(:user)
      task = create(:task, user: user)
      submission = build(:submission, user: user, task: task)

      expect(submission).not_to be_valid
      expect(submission.errors[:base]).to be_present
    end

    it 'enforces uniqueness of user per task' do
      task = create(:task)
      user = create(:user)

      allow_any_instance_of(Submission).to receive(:send_new_submission_email)
      allow_any_instance_of(Submission).to receive(:create_new_submission_notification)

      create(:submission, task: task, user: user)
      duplicate = build(:submission, task: task, user: user)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to be_present
    end
  end

  describe 'enums' do
    it 'defines expected statuses' do
      expect(Submission.statuses.keys).to match_array(%w[pending cancell_chosen accepted rejected])
    end
  end

  describe 'scopes' do
    before do
      allow_any_instance_of(Submission).to receive(:send_new_submission_email)
      allow_any_instance_of(Submission).to receive(:create_new_submission_notification)
    end

    describe '.for_task_statuses' do
      it 'filters by associated task status' do
        open_task = create(:task, status: :open)
        accepted_task = create(:task, status: :accepted)

        open_submission = create(:submission, task: open_task)
        _accepted_submission = create(:submission, task: accepted_task)

        result = Submission.for_task_statuses(:open)
        expect(result).to contain_exactly(open_submission)
      end
    end

    describe '.open_submissions' do
      it 'returns pending submissions for open tasks ordered by created_at desc' do
        task_open = create(:task, status: :open)
        older = create(:submission, task: task_open, created_at: 2.days.ago)
        newer = create(:submission, task: task_open, created_at: 1.day.ago)

        result = Submission.open_submissions
        expect(result).to eq([newer, older])
      end
    end

    describe '.accepted_submissions' do
      it 'returns accepted submissions for accepted tasks' do
        accepted_task = create(:task, status: :accepted)
        other_task = create(:task, status: :open)

        accepted_submission = create(:submission, task: accepted_task, status: :accepted)
        _other_submission = create(:submission, task: other_task, status: :accepted)

        result = Submission.accepted_submissions
        expect(result).to contain_exactly(accepted_submission)
      end
    end

    describe '.completed_task_submissions' do
      it 'returns accepted submissions for completed tasks' do
        completed_task = create(:task, status: :completed)
        other_task = create(:task, status: :accepted)

        completed_submission = create(:submission, task: completed_task, status: :accepted)
        _other_submission = create(:submission, task: other_task, status: :accepted)

        result = Submission.completed_task_submissions
        expect(result).to contain_exactly(completed_submission)
      end
    end

    describe '.rejected_submissions' do
      it 'returns submissions for non-open tasks that are not accepted' do
        cancelled_task = create(:task, status: :cancelled)
        overdue_task = create(:task, status: :overdue)
        accepted_task = create(:task, status: :accepted)

        rejected_on_cancelled = create(:submission, task: cancelled_task, status: :rejected)
        pending_on_overdue = create(:submission, task: overdue_task, status: :pending)
        accepted_on_accepted = create(:submission, task: accepted_task, status: :accepted)

        result = Submission.rejected_submissions
        expect(result).to include(rejected_on_cancelled, pending_on_overdue)
        expect(result).not_to include(accepted_on_accepted)
      end
    end
  end

  describe 'ransack allowlists' do
    it 'returns expected ransackable attributes' do
      expected = %w[id task_id user_id note status created_at updated_at]
      expect(Submission.ransackable_attributes).to include(*expected)
    end

    it 'returns expected ransackable associations' do
      expected = %w[task user answers notifications]
      expect(Submission.ransackable_associations).to match_array(expected)
    end
  end

  describe 'callbacks' do
    describe '#send_new_submission_sms' do
      let(:task_owner) { create(:user, phone_number: '48123456789') }
      let(:task) { create(:task, user: task_owner, title: 'Test Task') }
      let(:applicant) { create(:user, first_name: 'John') }
      let(:submission) { build(:submission, task: task, user: applicant, note: 'I can do it') }

      before do
        allow(submission).to receive(:send_new_submission_email)
        allow(submission).to receive(:create_new_submission_notification)
      end

      it 'sends an SMS with correct details using External::Sms::SmsSender' do
        expect(External::Sms::SmsSender).to receive(:send_now).with(
          to: '+48123456789',
          body: include('John', 'Test Task', 'I can do it')
        )

        submission.save!
      end

      context 'with various phone number formats' do
        [
          ['123456789', '+48123456789'],
          ['+48 123456789', '+48123456789'],
          ['+48123456789', '+48123456789'],
          ['0123456789', '+48123456789']
        ].each do |input_phone, expected_phone|
          it "normalizes '#{input_phone}' to '#{expected_phone}' before sending" do
            task_owner.update!(phone_number: input_phone)
            
            expect(External::Sms::SmsSender).to receive(:send_now).with(
              to: expected_phone,
              body: anything
            )
            
            submission.save!
          end
        end
      end
    end
  end
end
