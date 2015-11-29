# \ -s puma

Dir.glob('./{models,helpers,controllers,forms,services}/*.rb').each do |file|
  require file
end
run ApplicationController
