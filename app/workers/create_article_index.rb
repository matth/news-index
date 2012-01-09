class CreateArticleIndex
  @queue = :create_article_index

  def self.perform(url)
    return if ArticleIndex.first(:url => url)
    index =  ArticleIndex.create(:url => url)
    raise "Error creating index with #{url}" if !index.valid?
    Resque.enqueue(CreateArticleHtml, url)
  end

end