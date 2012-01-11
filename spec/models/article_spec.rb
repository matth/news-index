require "spec_helper"
require "ostruct"

describe Article do

  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:publication_date) }
  it { should validate_presence_of(:site_name) }
  it { should validate_presence_of(:site_section) }
  it { should validate_presence_of(:cps_id) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:body) }

  it 'should have many images' do
    Article.new.images.should == []
  end

  it 'should have many videos' do
    Article.new.videos.should == []
  end

  it 'should have many related_links' do
    Article.new.related_links.should == []
  end

  it "should belong to ArticleIndex" do
    Article.new.respond_to?(:article_index_id).should == true
  end

  describe 'create_from_html' do
    pending
  end

  describe 'update_from_html' do
    it "should update the article with the data" do
      data = OpenStruct.new(
        :title       => "title",
        :description => "description",
        :publication_date => Time.now,
        :url => "http://example.com/",
        :site_name => "bbc news",
        :site_section => "UK",
        :cps_id => "1234",
        :body => "foobar",
        :thumbnail => "http://example.com/test.jpg",
        :related_links => [1,2,3],
        :images => [ OpenStruct.new(:url => "1", :width => 1, :height => 1, :description => "1") ],
        :videos => [ OpenStruct.new(:playlist => "1", :width => 1, :height => 1, :description => "1", :external_id => 1, :holding_image => 1)],
      )
      DataExtractor.stub(:extract).and_return(data)
      article = Article.new
      article.update_from_html(:foo)
      article.type.should == "OpenStruct"
      article.publication_date.to_i.should == data.publication_date.to_i
      [:title, :description, :url, :site_name, :body, :site_section, :cps_id, :thumbnail, :related_links].each do |key|
        article.send(key).should == data.send(key)
      end

      article.images.size.should == 1
      article.images.first.url.should == data.images.first.url
      article.images.first.width.should == data.images.first.width
      article.images.first.height.should == data.images.first.height
      article.images.first.description.should == data.images.first.description

      article.videos.size.should == 1
      article.videos.first.playlist.should == data.videos.first.playlist
      article.videos.first.width.should == data.videos.first.width
      article.videos.first.height.should == data.videos.first.height

    end
  end

end
