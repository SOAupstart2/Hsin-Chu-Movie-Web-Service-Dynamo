require_relative 'spec_helper'
# require 'json'

describe 'Getting the root of the service' do
  it 'Should return ok' do
    get '/'
    last_response.must_be :ok?
    last_response.body.must_match(/api v/i, /welcome/i)
  end
end

describe 'Get film information' do
  # good
  TEST_SITES.each do |site|
    TEST_INFO.each do |t|
      it "must return same #{t} of movies for #{site}" do
        VCR.use_cassette("vieshow_#{t}_#{site}") do
          site_info = yml_load("#{FIXTURES}#{t}_#{site}.yml")
          if t == TEST_INFO[0]
            get "/api/v1/cinema/#{site}/movies"
            last_response.body.must_equal site_info.to_json
          else
            get "/api/v1/cinema/#{site}.json"
            last_response.body.must_equal site_info.to_s
          end
        end
      end
    end
  end

  # bad
  it 'should return 400 for id out of range' do
    FAIL_SITES.each do |id|
      get "/api/v1/cinema/#{id.to_i}/movies"
      last_response.status.must_equal 400
    end

    FAIL_SITES.each do |id|
      get "/api/v1/cinema/#{id}.json"
      last_response.status.must_equal 400
    end
  end
end

describe 'Redirect check' do
  header = {'CONTENT-TYPE' => 'application/json'}

  # good
  it 'should be redirect' do
    body = {'location'=>'taiwan', 'language'=>'ch'}
    post 'api/v1/users', body.to_json, header

    last_response.must_be :redirect?
    last_request.wont_equal ''

    next_location = last_response.location
    next_location.must_match /api\/v1\/users\/\d+/

    follow_redirect!
    last_request.url.must_match /api\/v1\/users\/\d+/
  end

  # bad
  it 'should return 400 for bad JSON formatting' do
    header = {'CONTENT-TYPE' => 'application/json'}
    body = 'aaaaaaaaaaaaaaaaaaaaaaaaa'

    post '/api/v1/users', body, header
    last_response.must_be :bad_request?
  end
end

# describe 'Outside of 1 and 14 must fail' do
#   Hen qi gwai
#   FAIL_SITES.each do |site|
#     TEST_INFO.each do |t|
#       it "must fail #{t} for #{site}" do
#         route = if t == TEST_INFO[0]
#           "/api/v1/cinema/#{site}/movies"
#         else
#           "/api/v1/cinema/#{site}.json"
#         end
#         get route
#         last_response.must_be :not_found?
#       end
#     end
#   end
# end
