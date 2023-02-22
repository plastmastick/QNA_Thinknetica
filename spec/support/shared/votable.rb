# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples "Votable" do
  let(:model) { described_class }

  it { is_expected.to have_many(:votes).dependent(:destroy) }

  describe 'return resource rating base on votes' do
    it 'with votes' do
      resource = create(model.to_s.underscore.to_sym)
      create(:vote, votable: resource)
      create(:vote, votable: resource)

      expect(resource.rating).to eq(-2)
    end

    it 'without votes' do
      expect(model.new.rating).to eq 0
    end
  end
end
