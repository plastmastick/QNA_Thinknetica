# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { is_expected.to belong_to :linkable }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  describe 'validate url format' do
    it 'with invalid value' do
      invalid_link = described_class.new(name: "InvalidUrl", url: "invalid", linkable: create(:question))

      expect(invalid_link).not_to be_valid
    end

    it 'with valid value' do
      new_link = described_class.new(name: "ValidUrl", url: "https://habr.com/", linkable: create(:question))

      expect(new_link).to be_valid
    end
  end

  describe 'gist logic' do
    let!(:gist_link) do
      create(:link,
             url: 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c',
             linkable: create(:question))
    end

    it 'identification gist link' do
      expect(gist_link.gist?).to be(true)
    end

    it 'identification not gist link' do
      link = create(:link, url: 'https://www.google.com/', linkable: create(:question))

      expect(link.gist?).to be(false)
    end
  end
end
