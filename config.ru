# \ -s puma

Dir.glob('./{models,helpers,config,values,services,controllers}/init.rb')
  .each do |file|
  require file
end

run ApplicationController
