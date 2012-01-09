require "spec_helper"

describe CreateArticleIndex do

  def valid_url
    "http://www.bbc.co.uk/news/world-us-canada-16380636"
  end

  context "ArticleIndex for given url exists:" do
    it "should not create an ArticleIndex" do
      ArticleIndex.create(:url => valid_url)
      ArticleIndex.should_not_receive(:create)
      CreateArticleIndex.perform(valid_url)
    end
    it "should not enqueue CreateArticleHtml" do
      ArticleIndex.create(:url => valid_url)
      Resque.should_not_receive(:enqueue).with(CreateArticleHtml, valid_url)
      CreateArticleIndex.perform(valid_url)
    end
  end

  context "ArticleIndex for given url does not exist:" do

    it "should create an ArticleIndex" do
      ArticleIndex.should_receive(:create).with(:url => valid_url).and_return(ArticleIndex.new(:url => valid_url))
      CreateArticleIndex.perform(valid_url)
    end

    it "should enqueue CreateArticleHtml with the url" do
      ArticleIndex.stub(:create).and_return(ArticleIndex.new(:url => valid_url))
      Resque.should_receive(:enqueue).with(CreateArticleHtml, valid_url)
      CreateArticleIndex.perform(valid_url)
    end

    it "should raise error if created object is invalid" do
      lambda { CreateArticleIndex.perform("http://example.com/") }.should raise_error
    end
  end

end
