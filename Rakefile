require './environment'
require 'resque/tasks'

desc "Run specs"
task :spec do
  ENV["RACK_ENV"] = "test"
  sh "bundle exec rspec spec"
end

desc "Generate coverage"
task :coverage do
  require "cover_me"
  CoverMe.complete!
end