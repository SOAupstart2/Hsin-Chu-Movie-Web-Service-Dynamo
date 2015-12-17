Dir.glob('models/*.rb').each do |file|
  require_relative "../#{file}" unless file == 'models/init.rb'
end
