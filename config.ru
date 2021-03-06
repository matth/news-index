# encoding: utf-8

require "./environment"
require 'resque/server'

map "/resque" do
  run Resque::Server.new
end

map "/api" do
  run Web
end