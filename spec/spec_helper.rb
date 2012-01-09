# encoding: utf-8

ENV["RACK_ENV"] = "test"

require "cover_me"

CoverMe.config.project.root = File.join(File.dirname(__FILE__), '..')
CoverMe.config.file_pattern = [/\/app\//i]

require File.join(File.dirname(__FILE__), '..', 'environment.rb')

require 'shoulda-matchers'
require 'database_cleaner'

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    Resque.stub(:enqueue)
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end