require "spec_helper"

describe CreateArticleData do

  def valid_url
    "http://www.bbc.co.uk/news/world-us-canada-16380636"
  end

  it "should raise an error if index cannot be found" do
    lambda { CreateArticleData.perform("http://example.com/") }.should raise_error
  end

  it "should call ArticleIndex.create_article_from_data and enqueue IndexArticleData" do
    index = ArticleIndex.create(:url => valid_url)
    index.should_receive(:create_article_from_data)
    ArticleIndex.stub(:first).with(:url => valid_url).and_return(index)
    Resque.should_receive(:enqueue).with(IndexArticleData, valid_url)
    CreateArticleData.perform(valid_url)
  end

end
