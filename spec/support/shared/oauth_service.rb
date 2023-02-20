# frozen_string_literal: true

shared_examples_for 'Oauth Service' do
  describe 'creates authorisation' do
    let!(:authorisation) { service.call.authorisations.first }

    it 'with provider' do
      expect(authorisation.provider).to eq auth.provider
    end

    it 'with uid' do
      expect(authorisation.uid).to eq auth.uid
    end
  end
end
