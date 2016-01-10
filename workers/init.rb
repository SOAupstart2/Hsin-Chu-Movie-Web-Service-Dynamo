Dir.glob('workers/*.rb').each do |file|
  require_relative "../#{file}" unless file == 'workers/init.rb'
end
