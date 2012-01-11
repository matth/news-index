class ArticleHtml
  include MongoMapper::Document
  key :html, String
  validates_presence_of :html
  belongs_to :article_index

  safe

  ensure_index [[:article_index_id, 1]], :unique => true

  def self.new_from_webpage(url)
    resp = http.get(url)
    if resp.code == 200
      self.new(:html => resp.body)
    else
      raise "Non 200 response for #{url}"
    end
  end

  def self.http
    @http ||= Typhoeus::Request
  end

end
