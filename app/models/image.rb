class Image

  include MongoMapper::EmbeddedDocument

  key :url, String
  key :width, Integer
  key :height, Integer
  key :description, String

  validates_presence_of :url, :width, :height

  belongs_to :article

  def serializable_hash(options = {})
    super({:except => [:id, :article_id]}.merge(options))
  end

end
