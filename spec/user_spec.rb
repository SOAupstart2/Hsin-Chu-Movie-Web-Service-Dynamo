require_relative 'spec_helper'

describe 'Redirect check' do
  header = { 'CONTENT_TYPE' => 'application/json' }

  # it 'should be redirect' do
  #   body = {
  #     location: 'hsinchu',
  #     language: 'chinese',
  #     search: 'test'
  #   }
  #   post 'api/v1/users', body.to_json, header

  #   last_response.must_be :redirect?
  #   last_request.wont_equal ''

  #   next_location = last_response.location
  #   next_location.must_match %r{/api\/v1\/users\/\w+}

  #   follow_redirect!
  #   last_request.url.must_match %r{/api\/v1\/users\/\w+}
  end
end
