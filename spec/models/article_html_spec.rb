require "spec_helper"
require "ostruct"

describe ArticleHtml do

  it { should validate_presence_of(:html) }

  it "should belong to ArticleIndex" do
    ArticleHtml.new.respond_to?(:article_index_id).should == true
  end

  describe "ArticleHtml.new_from_webpage" do
    it "should raise an error with a non 200 response" do
      ArticleHtml.http.stub(:get).and_return(OpenStruct.new :code => 404)
      lambda { ArticleHtml.new_from_webpage(:foo) }.should raise_error
    end
    it "should return a new ArticleHtml object with page html" do
      ArticleHtml.http.stub(:get).and_return(OpenStruct.new :code => 200, :body => "HELLO WORLD")
      ArticleHtml.new_from_webpage(:foo).class.should == ArticleHtml
      ArticleHtml.new_from_webpage(:foo).html.should  == "HELLO WORLD"
    end
  end

end