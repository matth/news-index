class Article

  include MongoMapper::Document

  key :type, String
  key :title, String
  key :body, String
  key :description, String
  key :publication_date, Time
  key :site_name, String
  key :site_section, String
  key :cps_id, String
  key :url, String
  key :thumbnail, String
  key :related_links,  Array, :default => []
  timestamps!

  validates_presence_of :type, :title, :body, :publication_date, :description, :site_name, :site_section, :cps_id, :url

  belongs_to :article_index

  safe

  ensure_index [[:article_index_id, 1]], :unique => true
  ensure_index [[:url, 1]], :unique => true

  many :images
  many :videos

  def self.new_from_html(html)
    article = self.new
    article.update_from_html(html)
    article
  end

  def update_from_html(html)
    data = DataExtractor.extract(html)
    self.type = data.class.to_s
    [:title, :description, :body, :publication_date, :url, :site_name, :site_section, :cps_id, :thumbnail, :related_links].each do |key|
      self.send(:"#{key}=", data.send(key))
    end

    data.images.each do |i|
      self.images << Image.new(:url => i.url, :width => i.width, :height => i.height, :description => i.description)
    end

    data.videos.each do |v|
      self.videos << Video.new(:playlist => v.playlist, :width => v.width, :height => v.height, :holding_image => v.holding_image, :external_id => v.external_id)
    end

  end

end