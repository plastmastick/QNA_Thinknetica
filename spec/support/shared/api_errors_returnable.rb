# frozen_string_literal: true

shared_examples_for 'API errors returnable' do
  it 'returns errors json' do
    do_request(method, api_path, params: params)
    expect(json['errors']).not_to be_blank
  end

  it 'returns unsuccessful status' do
    do_request(method, api_path, params: params)
    expect(response.status).not_to have_http_status(:success)
  end
end
