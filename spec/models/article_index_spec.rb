require "spec_helper"

describe ArticleIndex do

  it { should validate_presence_of(:url) }

  it "should have one ArticleHtml" do
    article = ArticleIndex.create(:url => "http://www.bbc.co.uk/news/world-us-canada-16380636")
    article.article_html.should == nil
    article.article_html = ArticleHtml.create
    article.article_html.class.should == ArticleHtml
  end

  it "should validate url as belonging to BBC News" do
    ArticleIndex.new(:url => "foobar").valid?.should == false
    ArticleIndex.new(:url => "http://www.google.com/").valid?.should == false
    ArticleIndex.new(:url => "http://www.bbc.co.uk/news/world-us-canada-16380636").valid?.should == true
  end

  describe "create_article_html_from_webpage" do
    it "should set article_html to new article html object from webpage" do
      url = "http://www.bbc.co.uk/news/world-us-canada-16380636"
      ArticleHtml.should_receive(:new_from_webpage).with(url).and_return(ArticleHtml.new(:html => "foobar"))
      index = ArticleIndex.create(:url => url)
      index.create_article_html_from_webpage
      index.article_html.html.should == "foobar"
    end
    it "should update article_html if one exists" do
      url  = "http://www.bbc.co.uk/news/world-us-canada-16380636"
      html = ArticleHtml.create(:html => "foo")
      ArticleHtml.should_receive(:new_from_webpage).with(url).and_return(ArticleHtml.new(:html => "bar"))
      index = ArticleIndex.create(:url => url, :article_html => html)
      index.create_article_html_from_webpage
      index.article_html.html.should == "bar"
      index.article_html.id.should   == html.id
    end
  end

end