require 'rails_helper'

RSpec.describe TaskMessage, type: :model do
  describe 'factories' do
    it 'has a valid question factory' do
      message = build(:task_message)
      expect(message).to be_valid
      expect(message).to be_question
    end

    it 'has a valid reply factory' do
      message = build(:task_message, :reply)
      expect(message).to be_valid
      expect(message).to be_reply
      expect(message.parent).to be_present
    end
  end

  describe 'validations' do
    it 'requires a body' do
      msg = build(:task_message, body: nil)
      expect(msg).not_to be_valid
      expect(msg.errors[:body]).to be_present
    end

    it 'limits body length to 2000 characters' do
      msg = build(:task_message, body: 'a' * 2001)
      expect(msg).not_to be_valid
      expect(msg.errors[:body]).to be_present
    end
  end

  describe 'scopes' do
    it '.root returns messages without parent' do
      root = create(:task_message, parent: nil)
      _child = create(:task_message, :reply, parent: root)

      expect(TaskMessage.root).to include(root)
      expect(TaskMessage.root).not_to include(_child)
    end

    it '.recent orders by created_at desc' do
      older = create(:task_message, created_at: 2.days.ago)
      newer = create(:task_message, created_at: 1.day.ago)

      expect(TaskMessage.recent.first).to eq(newer)
    end
  end

  describe '#root?' do
    it 'is true when parent is nil' do
      msg = build(:task_message, parent: nil)
      expect(msg.root?).to be true
    end

    it 'is false when parent is present' do
      parent = create(:task_message)
      msg = create(:task_message, :reply, parent: parent)
      expect(msg.root?).to be false
    end
  end

  describe 'thread helpers' do
    let(:task) { create(:task) }
    let(:user) { task.user }

    it '#thread_root returns the top-most parent' do
      root = create(:task_message, task: task, user: user)
      child = create(:task_message, :reply, task: task, user: user, parent: root)
      grandchild = create(:task_message, :reply, task: task, user: user, parent: child)

      expect(grandchild.thread_root).to eq(root)
    end

    it '#thread_messages_flat returns depth-first ordered list' do
      root = create(:task_message, task: task, user: user, created_at: 3.days.ago)
      child1 = create(:task_message, :reply, task: task, user: user, parent: root, created_at: 2.days.ago)
      child2 = create(:task_message, :reply, task: task, user: user, parent: root, created_at: 1.day.ago)

      flat = root.thread_messages_flat
      expect(flat).to eq([root, child1, child2])
    end

    it '#thread_latest_message returns the newest in the thread' do
      root = create(:task_message, task: task, user: user, created_at: 3.days.ago)
      _older = create(:task_message, :reply, task: task, user: user, parent: root, created_at: 2.days.ago)
      latest = create(:task_message, :reply, task: task, user: user, parent: root, created_at: 1.day.ago)

      expect(root.thread_latest_message).to eq(latest)
    end
  end

  describe '#replying_to_user' do
    let(:task_owner) { create(:user) }
    let(:task) { create(:task, user: task_owner) }
    let(:author) { create(:user) }

    it 'returns task owner when no parent' do
      msg = create(:task_message, task: task, user: author, parent: nil)
      expect(msg.replying_to_user).to eq(task_owner)
    end

    it 'returns first ancestor with different author' do
      root = create(:task_message, task: task, user: task_owner)
      child_same_author = create(:task_message, :reply, task: task, user: author, parent: root)
      grandchild_same_author = create(:task_message, :reply, task: task, user: author, parent: child_same_author)

      expect(grandchild_same_author.replying_to_user).to eq(task_owner)
    end
  end

  describe 'callbacks' do
    it 'sends new question email for question messages' do
      msg = build(:task_message, message_type: :question)
      allow(msg).to receive(:send_new_question_email)

      msg.save!

      expect(msg).to have_received(:send_new_question_email)
    end

    it 'sends new reply email for reply messages' do
      msg = build(:task_message, :reply)
      allow(msg).to receive(:send_new_reply_email)

      msg.save!

      expect(msg).to have_received(:send_new_reply_email)
    end
  end

  describe 'ransack allowlists' do
    it 'returns expected attributes' do
      expected = %w[id task_id user_id parent_id body message_type created_at updated_at]
      expect(TaskMessage.ransackable_attributes).to include(*expected)
    end

    it 'returns expected associations' do
      expected = %w[task user parent replies]
      expect(TaskMessage.ransackable_associations).to match_array(expected)
    end
  end
end
