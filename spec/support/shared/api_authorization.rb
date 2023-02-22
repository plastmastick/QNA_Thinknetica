# frozen_string_literal: true

shared_examples_for 'API Authorizable' do
  context 'when unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response).to have_http_status :unauthorized
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response).to have_http_status :unauthorized
    end
  end

  context 'when authorized' do
    it 'returns 200 status' do
      do_request(method, api_path, params: request_params, headers: headers)
      expect(response).to have_http_status :ok
    end
  end
end
