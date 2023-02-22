# frozen_string_literal: true

shared_examples_for 'API Returned Fields' do
  it 'returns all public fields' do
    public_fields&.each do |attr|
      expect(responce_json_object[attr]).to eq resource.send(attr).as_json
    end
  end

  it 'does not return private fields' do
    private_fields&.each do |attr|
      expect(responce_json_object).not_to have_key(attr)
    end
  end
end
