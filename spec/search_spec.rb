require_relative 'spec_helper'

SEARCH_NAME = 'star'
SEARCH_TIME = '18:00'

describe 'tests for search route' do
  LANGUAGE.each do |lang|
    url = "/api/v1/search?location=hsinchu&language=#{lang}"\
          "&name=#{SEARCH_NAME}&time=#{SEARCH_TIME}"
    it "search must succeed for #{lang}" do
      get url
      last_response.status.must_equal 200
      result = JSON.parse last_response.body
      result['search_info']['location'].must_equal 'hsinchu'
      result['search_info']['language'].must_equal lang
      result['search_info']['search_name'].must_equal SEARCH_NAME
      result['search_info']['search_time'].must_equal SEARCH_TIME
      result['search_name'].class.must_equal Hash
      result['search_time'].class.must_equal Hash
      sleep 03
    end
  end
end
