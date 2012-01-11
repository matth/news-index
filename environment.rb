# encoding: utf-8

require 'rubygems'
require 'bundler'

Bundler.require

Encoding.default_internal, Encoding.default_external = ['utf-8'] * 2

# DB Config
RACK_ENV ||= ENV["RACK_ENV"] || "development"
LOGGER   = Logger.new($stdout)
LOGGER.level = Logger::WARN
dbconfig = YAML.load(File.read("config/database.yml"))[RACK_ENV]
MongoMapper.connection = Mongo::Connection.new(dbconfig['host'] || 'localhost', dbconfig['port'] || 27017, :logger => LOGGER)
MongoMapper.database   = dbconfig['database']

# Redis + Resque
uri = URI.parse('http://localhost:6379')
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Resque.redis.namespace = "resque:news-index"

# Time zone
Time.zone = "London"

# Load App code
$: << "#{File.dirname(__FILE__)}/app"
$: << "#{File.dirname(__FILE__)}/lib"

def require_alphabetically(files)
  files.sort.each { |p| require p }
end

require_alphabetically Dir.glob("#{File.dirname(__FILE__)}/lib/**/*.rb")
require_alphabetically Dir.glob("#{File.dirname(__FILE__)}/app/**/*.rb")
require_alphabetically Dir.glob("#{File.dirname(__FILE__)}/config/initializers/*.rb")
