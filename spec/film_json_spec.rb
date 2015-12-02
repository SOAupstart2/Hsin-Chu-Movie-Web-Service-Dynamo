require_relative 'spec_helper'

describe 'Get film json for Cinema' do
  CINEMA.each do |cinema, sites|
    sites.each do |site|
      LANGUAGE.each do |lang|
        it "must return json for #{cinema}-#{site} in #{lang}" do
          VCR.use_cassette("#{cinema}_table_#{site}_#{lang}") do
            site_info = yml_load("#{FIX[cinema]}table_#{site}_#{lang}.yml")
            get "/api/v1/#{cinema}/#{lang}/#{site}.json"
            last_response.body.must_equal site_info.to_s
          end; end; end; end
  end
end
