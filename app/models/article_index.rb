class ArticleIndex

  include MongoMapper::Document

  key :url, String
  timestamps!

  validates_presence_of :url
  validate :url_is_bbc_news

  one :article_html
  one :article

  def create_article_from_data
    raise "No associated html object for #{self.url}" if self.article_html.nil?
    if self.article.nil?
      article = Article.new_from_html(self.article_html.html)
      self.article = article
      article.article_index = self
      article.save
      self.save
    else
      self.article.update_from_html(self.article_html.html)
      self.save
    end
  end

  def create_article_html_from_webpage
    html = ArticleHtml.new_from_webpage(self.url)
    if self.article_html.nil?
      self.article_html = html
      self.save
    else
      self.article_html.html = html.html
      self.save
      html.save
    end
  end

  private

  def url_is_bbc_news
    if self.url !~ /^http:\/\/(www)?\.bbc\.co\.uk\/news/
      errors.add(:url, "is not a bbc news url")
    end
  end

end