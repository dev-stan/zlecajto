# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'factories' do
    it 'has a valid factory' do
      expect(build(:task)).to be_valid
    end
  end

  describe 'validations' do
    it 'is invalid without a title' do
      task = build(:task, title: nil)
      expect(task).not_to be_valid
      expect(task.errors[:title]).to be_present
    end

    it 'validates inclusion of category' do
      task = build(:task, category: 'InvalidCat')
      expect(task).not_to be_valid
      expect(task.errors[:category]).to be_present
    end

    it 'validates inclusion of timeslot' do
      task = build(:task, timeslot: 'Night')
      expect(task).not_to be_valid
      expect(task.errors[:timeslot]).to be_present
    end

    it 'validates inclusion of location' do
      task = build(:task, location: 'Atlantis')
      expect(task).not_to be_valid
      expect(task.errors[:location]).to be_present
    end

    it 'is valid without optional salary' do
      task = build(:task, salary: nil)
      expect(task).to be_valid
    end
  end

  describe 'enums' do
    it 'defines expected statuses' do
      expect(Task.statuses.keys).to match_array(%w[open cancelled accepted completed overdue])
    end

    it 'defaults status to open' do
      expect(create(:task).status).to eq('open')
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      expect(build(:task).user).to be_present
    end

    it 'has many submissions with dependent destroy' do
      allow_any_instance_of(Submission).to receive(:send_new_submission_email)
      allow_any_instance_of(Submission).to receive(:create_new_submission_notification)
      task = create(:task)
      create_list(:submission, 2, task: task)
      expect { task.destroy }.to change { Submission.count }.by(-2)
    end

    it 'has many task_messages with dependent destroy' do
      task = create(:task)
      create_list(:task_message, 2, task: task)
      expect { task.destroy }.to change { TaskMessage.count }.by(-2)
    end
  end

  describe 'attachments' do
    it 'allows multiple photos to be attached' do
      task = create(:task)
      file_path = Rails.root.join('public/robots.txt')
      2.times do |i|
        task.photos.attach(io: File.open(file_path), filename: "robots_#{i}.txt", content_type: 'text/plain')
      end
      expect(task.photos.count).to eq(2)
    end
  end

  describe 'scopes' do
    describe '.with_submissions' do
      it 'eager loads submissions' do
        allow_any_instance_of(Submission).to receive(:send_new_submission_email)
        allow_any_instance_of(Submission).to receive(:create_new_submission_notification)
        task_with_submission = create(:task)
        create(:submission, task: task_with_submission)
        tasks = Task.with_submissions.where(id: task_with_submission.id).to_a
        expect(tasks.first.association(:submissions)).to be_loaded
      end
    end
  end

  describe 'ransack allowlists' do
    it 'returns expected ransackable attributes' do
      expected = %w[id title description salary status user_id category due_date location payment_method timeslot
                    created_at updated_at]
      expect(Task.ransackable_attributes).to include(*expected)
    end

    it 'returns expected ransackable associations' do
      expected = %w[user submissions task_messages notifications]
      expect(Task.ransackable_associations).to match_array(expected)
    end
  end
end
