class CreateArticleIndex < ActiveRecord::Migration
  def self.up
    create_table :article_indices do |t|
      t.string    :url
      t.datetime  :last_indexed
      t.timestamps
    end
  end
  def self.down
    drop_table :article_indices
  end
end
