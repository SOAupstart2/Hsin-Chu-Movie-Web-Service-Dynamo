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

  it 'should return 400 for bad request' do
    get '/api/v1/search?body=aaaaaaaaaaaaaaaaaaaaaaaaa'
    last_response.must_be :bad_request?
  end

  it 'should be fail for not \'english\' of \'chinese\'' do
    get '/api/v1/search?location=hsinchu&langauge=ch'
    last_response.must_be :bad_request?
  end
end
