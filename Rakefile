require 'rake/testtask'

task :build do
  sh 'bundle exec bgem'
end

task :format do
  sh 'bundle exec rufo lib/hobby/json/keys.rb || true'
end

Rake::TestTask.new

task :default => [:build, :format, :test]
