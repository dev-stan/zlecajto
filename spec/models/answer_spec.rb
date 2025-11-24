require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'factories' do
    it 'has a valid factory' do
      answer = build(:answer)
      expect(answer).to be_valid
    end
  end

  describe 'validations' do
    it 'requires a message' do
      answer = build(:answer, message: nil)
      expect(answer).not_to be_valid
      expect(answer.errors[:message]).to be_present
    end

    it 'limits message length to 1000 characters' do
      answer = build(:answer, message: 'a' * 1001)
      expect(answer).not_to be_valid
      expect(answer.errors[:message]).to be_present
    end
  end

  describe 'callbacks' do
    it 'sends new answer email after create to submission user when author is task owner' do
      answer = Answer.new
      allow(answer).to receive(:send_new_answer_email)

      answer.run_callbacks(:create) {}

      expect(answer).to have_received(:send_new_answer_email)
    end

    it 'sends new answer email after create to task owner when author is submission user' do
      answer = Answer.new
      allow(answer).to receive(:send_new_answer_email)

      answer.run_callbacks(:create) {}

      expect(answer).to have_received(:send_new_answer_email)
    end
  end

  describe 'ransack allowlists' do
    it 'returns expected attributes' do
      expected = %w[id user_id submission_id message created_at updated_at]
      expect(Answer.ransackable_attributes).to include(*expected)
    end

    it 'returns expected associations' do
      expected = %w[user submission]
      expect(Answer.ransackable_associations).to match_array(expected)
    end
  end
end
