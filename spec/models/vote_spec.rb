# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { is_expected.to belong_to :votable }
  it { is_expected.to validate_presence_of :value }

  describe 'validate value' do
    it 'with invalid value' do
      invalid_value = described_class.new(value: 2, votable: create(:answer))

      expect(invalid_value).not_to be_valid
    end

    it 'with valid value' do
      valid_value = described_class.new(value: -1, votable: create(:answer), user: create(:user))

      expect(valid_value).to be_valid
    end
  end
end
