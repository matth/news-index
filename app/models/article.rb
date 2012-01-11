class Article

  include MongoMapper::Document

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

  validates_presence_of :title, :body, :publication_date, :description, :site_name, :site_section, :cps_id, :url, :thumbnail

  many :images
  many :videos

end