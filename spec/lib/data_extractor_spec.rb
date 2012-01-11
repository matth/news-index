require 'spec_helper'

def html(fname)
  File.open("spec/fixtures/html/#{fname}.html").read
end

describe DataExtractor::Video do
  it "should have a playlist, width, height, holding image and external ID" do
    video = DataExtractor::Video.new("http://example.com/playlist.xml", 100, 100, "http://example.com/test.jpg", "p00n3ff7")
    video.playlist.should    == "http://example.com/playlist.xml"
    video.external_id.should  == "p00n3ff7"
    video.width.should  == 100
    video.height.should == 100
    video.holding_image.should    == "http://example.com/test.jpg"
  end
end

describe DataExtractor::Image do
  it "should have a url, width, height and description" do
    img = DataExtractor::Image.new("http://example.com/test.jpg", 100, 100, "A test image")
    img.url.should    == "http://example.com/test.jpg"
    img.width.should  == 100
    img.height.should == 100
    img.description.should == "A test image"
  end
  describe ".area" do
    it 'should calculate the area' do
      img = DataExtractor::Image.new("http://example.com/test.jpg", 100, 100, "A test image")
      img.area.should == 10_000
    end
  end
end

describe DataExtractor::Document do

  include DataExtractor

  it "should extract the title" do
    Document.new(html("article_emp")).title.should == "High-speed rail line to go ahead"
  end

  it "should extract the description" do
    Document.new(html("article_emp")).description.should == "A new high-speed rail line between London and Birmingham, which the government says will boost the economy, gets the go-ahead despite strong opposition."
  end

  it "should extract the publication_date" do
    Document.new(html("article_emp")).publication_date.should == Time.mktime(2012, 01, 10, 12, 6, 57)
  end

  it "should extract the site name" do
    Document.new(html("article_emp")).site_name.should  == "BBC News"
  end

  it "should extract the site section" do
    Document.new(html("article_emp")).site_section.should  == "UK"
  end

  it "should extract the cps id" do
    Document.new(html("article_emp")).cps_id.should  == "16478954"
  end

  it "should extract the url" do
    Document.new(html("article_emp")).url.should   == "http://www.bbc.co.uk/news/uk-16478954"
  end

  it "should extract the thumbnail" do
    Document.new(html("article_emp")).thumbnail.should == "http://news.bbcimg.co.uk/media/images/57788000/jpg/_57788322_hs2.jpg"
  end

  it "should extract all images with an area of over 40K" do
    Document.new(html("article_emp")).images.should == [
      Image.new("http://news.bbcimg.co.uk/media/images/57792000/gif/_57792582_uk_rail_highspeed2_304.gif", 304, 390, "High-speed rail line route map"),
      Image.new("http://news.bbcimg.co.uk/media/images/57788000/jpg/_57788321_013642711-1.jpg", 304, 171, "Undated handout image issued by HS2 of the Birmingham and Fazeley viaduct, part of the new proposed route for the HS2 high speed rail scheme ")
    ]
  end

  it "should extract all video media" do
    Document.new(html("article_emp")).videos.size.should == 1
    Document.new(html("article_emp")).videos.first.width.should         == 448
    Document.new(html("article_emp")).videos.first.height.should        == 252
    Document.new(html("article_emp")).videos.first.external_id.should   == "p00n3ff7"
    Document.new(html("article_emp")).videos.first.playlist.should      == "http://playlists.bbc.co.uk/news/uk-16484105A/playlist.sxml"
    Document.new(html("article_emp")).videos.first.holding_image.should == "http://news.bbcimg.co.uk/media/images/57791000/jpg/_57791992_jex_1284595_de27-1.jpg"
  end

end