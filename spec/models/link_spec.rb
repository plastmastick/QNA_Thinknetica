# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { is_expected.to belong_to :linkable }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  describe 'validate url format' do
    it 'with invalid value' do
      link = described_class.new(name: "InvalidUrl", url: "invalid", linkable: create(:question))

      expect(link).not_to be_valid
    end

    it 'with valid value' do
      link = described_class.new(name: "ValidUrl", url: "https://habr.com/", linkable: create(:question))

      expect(link).to be_valid
    end
  end
end
