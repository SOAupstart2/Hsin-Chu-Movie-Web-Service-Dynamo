require 'json'
require 'shoryuken'
require 'config_env'

ConfigEnv.path_to_config("#{__dir__}/../config/config_env.rb")

# Queue to save a URL to SQS queue
class SaveUrlWorker
  include Shoryuken::Worker
  shoryuken_options queue: 'kandianying_moocher', auto_delete: false

  def perform(search_info_hash)
    puts search_info_hash
  end
end
