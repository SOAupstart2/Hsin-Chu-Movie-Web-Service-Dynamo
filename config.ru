# \ -s puma

Dir.glob('./{models,helpers,config,values,services,controllers,workers}/'\
  'init.rb').each do |file|
  require file
end

run ApplicationController
