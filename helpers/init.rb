Dir.glob('helpers/*.rb').each do |file|
  require_relative "../#{file}" unless file == 'helpers/init.rb'
end
