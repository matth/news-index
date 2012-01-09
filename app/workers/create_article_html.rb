class CreateArticleHtml
  @queue = :create_article_html

  def self.perform(url)
    index = ArticleIndex.first(:url => url)
    raise "Cannot find ArticleIndex for #{url}" if index.nil?
    index.create_article_html_from_webpage
    Resque.enqueue(CreateArticleData, url)
  end

end