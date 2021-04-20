require 'rake/testtask'

Rake::TestTask.new

task :bgem do
  sh 'bundle exec bgem'
end

task :default => [:bgem, :test]
