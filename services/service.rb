require 'virtus'

##
# Value object for results from searching cinema info
class CrawlResult
  include Virtus.model

  attribute :name
  attribute :time

  def to_json
    to_hash.to_json
  end
end

##
# Service object to check tutorial request from API
class CheckTutorialFromAPI
  def initialize(api_url, form)
    @api_url = api_url
    params = form.attributes.delete_if { |_, value| value.blank? }
    @options =  { body: params.to_json,
                  headers: { 'Content-Type' => 'application/json' }
                }
  end

  def call
    results = HTTParty.post(@api_url, @options)
    crawl_results = CrawlResult.new(results)
    crawl_results.code = results.code
    crawl_results.id = results.request.last_uri.path.split('/').last
    crawl_results
  end
end
