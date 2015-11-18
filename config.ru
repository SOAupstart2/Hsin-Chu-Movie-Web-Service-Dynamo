# \ -s puma

Dir.glob('./{models,helpers,controllers,forms}/*.rb').each { |file| require file }
run ApplicationController
