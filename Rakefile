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

namespace :enqueue do

  task :create_article_index do
    ["2011-09", "2011-10", "2011-11", "2011-12", "2012-01"].each do |month|
      resp = Typhoeus::Request.get "http://matt.chadburn.co.uk/projects/picadilly/logs/sorted/#{month}.sorted"
      raise "Error downloading #{month}" if resp.code != 200
      resp.body.split("\n").each do |url|
        Resque.enqueue(CreateArticleIndex, url.strip)
      end
    end
  end

  task :create_article_html do
    ArticleIndex.find_each(:batch_size => 10000) do |index|
      Resque.enqueue(CreateArticleHtml, index.url)
    end
  end

  task :create_article_data do
    ArticleHtml.find_each(:batch_size => 10000) do |html|
      Resque.enqueue(CreateArticleData, html.article_index.url)
    end
  end

end

task :counts do
  p ArticleHtml.count
  res = StoryBodyCounter.build.find()
  p res
end