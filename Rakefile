Dir.glob('./{models,helpers,config,values,services,controllers}/init.rb').each do |file|
  require file
end
require 'sinatra/activerecord/rake'
require 'rake/testtask'

task default: :spec

desc 'Run all tests'
Rake::TestTask.new(name = :spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end
