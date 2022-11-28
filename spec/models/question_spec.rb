# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to belong_to :author }

  it { is_expected.to have_one(:reward).dependent(:destroy) }

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:links).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }
  it { is_expected.to accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'return answer rating base on votes' do
    it 'with votes' do
      resource = create(:question)
      create(:vote, votable: resource)
      create(:vote, votable: resource)

      expect(resource.rating).to eq(-2)
    end

    it 'without votes' do
      expect(described_class.new.rating).to eq 0
    end
  end
end
