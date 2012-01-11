class Image

  include MongoMapper::EmbeddedDocument

  key :url, String
  key :width, Integer
  key :height, Integer
  key :description, String

  validates_presence_of :url, :width, :height

  belongs_to :article

end
