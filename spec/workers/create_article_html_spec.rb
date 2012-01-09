require "spec_helper"

describe CreateArticleHtml do

  def valid_url
    "http://www.bbc.co.uk/news/world-us-canada-16380636"
  end

  it "should raise an error if index cannot be found" do
    lambda { CreateArticleHtml.perform("http://example.com/") }.should raise_error
  end

  it "should call ArticleIndex.create_article_html_from_webpage and enqueue CreateArticleData" do
    index = ArticleIndex.create(:url => valid_url)
    index.should_receive(:create_article_html_from_webpage)
    ArticleIndex.stub(:first).with(:url => valid_url).and_return(index)
    Resque.should_receive(:enqueue).with(CreateArticleData, valid_url)
    CreateArticleHtml.perform(valid_url)
  end

end
