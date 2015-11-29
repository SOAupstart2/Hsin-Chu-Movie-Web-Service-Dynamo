# \ -s puma

Dir.glob('./{models,helpers,controllers,forms,services,values}/*.rb')
  .each do |file|
  require file
end
run ApplicationController
