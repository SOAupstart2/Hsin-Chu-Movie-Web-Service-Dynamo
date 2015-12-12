require 'rake/testtask'
require 'config_env/rake_tasks'

task default: :spec

desc "Run all tests"
Rake::TestTask.new(name=:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end
