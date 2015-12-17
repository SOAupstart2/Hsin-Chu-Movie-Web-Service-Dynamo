require_relative 'spec_helper'

# TODO: Original bad tests, needs work
describe 'Bad Tests' do
  CINEMA.each do |cinema, _|
    fail_sites = if cinema.to_s == 'vieshow' then VIESHOW_FAIL_SITES
                 elsif cinema.to_s == 'ambassador' then AMB_FAIL_SITES
                 end
    fail_sites.each do |id|
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

  it 'should be fail for not \'english\' of \'chinese\'' do
    header = { 'CONTENT-TYPE' => 'application/json' }
    body = { 'location' => 'hsinchu', 'language' => 'ch' }
    post 'api/v1/users', body.to_json, header
    last_response.must_be :bad_request?
  end
end
