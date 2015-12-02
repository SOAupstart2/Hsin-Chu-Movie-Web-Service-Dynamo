require_relative 'spec_helper'

# TODO: Original bad tests, needs work
describe 'Bad Tests' do
  CINEMA.each do |cinema, _|
    FAIL_SITES.each do |id|
      LANGUAGE.each do |lang|
        it 'should return 400 for bad id' do
          get "/api/v1/#{cinema}/#{lang}/#{id.to_i}/movies"
          last_response.status.must_equal 400
          get "/api/v1/#{cinema}/#{lang}/#{id.to_i}.json"
          last_response.status.must_equal 400
        end; end; end
  end

  it 'should return 400 for bad JSON formatting' do
    header = { 'CONTENT-TYPE' => 'application/json' }
    body = 'aaaaaaaaaaaaaaaaaaaaaaaaa'

    post '/api/v1/users', body, header
    last_response.must_be :bad_request?
  end
end
