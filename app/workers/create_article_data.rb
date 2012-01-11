class CreateArticleData
  @queue = :create_article_data

  def self.perform(url)
    index = ArticleIndex.first(:url => url)
    raise "Cannot find ArticleIndex for #{url}" if index.nil?
    index.create_article_from_data
    Resque.enqueue(IndexArticleData, url)
  end

end