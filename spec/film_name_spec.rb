require_relative 'spec_helper'

describe 'Get film name for Cinema' do
  CINEMA.each do |cinema, sites|
    sites.each do |site|
      LANGUAGE.each do |lang|
        it "must return film names for #{cinema}-#{site} in #{lang}" do
          VCR.use_cassette("#{cinema}_name_#{site}_#{lang}") do
            site_info = yml_load("#{FIX[cinema]}name_#{site}_#{lang}.yml")
            get "/api/v1/#{cinema}/#{lang}/#{site}/movies"
            last_response.body.must_equal site_info.to_json
          end; end; end; end
  end
end
