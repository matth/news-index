class Video

  include MongoMapper::EmbeddedDocument

  key :playlist, String
  key :width, Integer
  key :height, Integer
  key :external_id, String
  key :holding_image, String

  validates_presence_of :playlist, :width, :height, :external_id

  belongs_to :article


end