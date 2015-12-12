require 'config_env/rake_tasks'
require 'rake/testtask'

task default: :spec

# task :config do
ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")
# end

desc 'Run all tests'
Rake::TestTask.new(name = :spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end
