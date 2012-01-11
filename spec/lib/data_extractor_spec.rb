# encoding: utf-8

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

describe DataExtractor do
  describe ".extract" do
    it "should return the correct document type" do
      DataExtractor.extract(html("article_emp")).class.should == DataExtractor::ArticleDocument
      DataExtractor.extract(html("video")).class.should == DataExtractor::VideoDocument
      DataExtractor.extract(html("picture_gallery")).class.should == DataExtractor::PictureGalleryDocument
    end
    it "should raise an error if it cannot detect type" do
      lambda { DataExtractor.extract(html("unknown")) }.should raise_error
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

  it "should extract the related links" do
    Document.new(html("article_emp")).related_links.should == [
      "http://www.bbc.co.uk/news/uk-16485263",
      "http://www.bbc.co.uk/news/uk-england-16483814",
      "http://www.bbc.co.uk/news/business-16467903"
    ]
  end

end

describe DataExtractor::ArticleDocument do
  it "should extract body text correctly" do
    DataExtractor::ArticleDocument.new(html("article_emp")).body.should == [
      %Q{<p>A controversial new high-speed rail line between London and Birmingham has been given the go-ahead by government.</p>},
      %Q{<p>This first phase of High Speed Two (HS2) could be running by 2026, later extending to northern England.</p>},
      %Q{<p><a href="http://www.dft.gov.uk/news/statements/greening-20120110">Transport Secretary Justine Greening has announced extra tunnelling along the 90-mile (140km) first phase</a> in response to environmental concerns.</p>},
      %Q{<p>Opponents also dispute government claims HS2 will deliver benefits worth up to £47bn, at costs of about £33bn.</p>},
      %Q{<p>The first phase of the project would cut London-Birmingham journey times, on 225mph trains, to 49 minutes, Ms Greening said.</p>},
      %Q{<p>This would be followed by a second phase of Y-shaped track reaching Manchester and Leeds by about 2033.</p>},
      %Q{<p>Connections to existing lines should then cut journey times between London, and Edinburgh and Glasgow, to three-and-a-half hours.</p>},
      %Q{<p>Ms Greening called the line "the most significant transport infrastructure project since the building of the motorways".</p>},
      %Q{<p>"By following in the footsteps of the 19th Century railway pioneers, the government is signalling its commitment to providing 21st Century infrastructure and connections - laying the groundwork for long-term, sustainable economic growth," she said.</p>},
      %Q{<p>The government estimates that the project could eventually result in 9 million road journeys and 4.5 million journeys by plane instead being taken by train every year.</p>},
      %Q{<p>"HS2 is therefore an important part of transport's low-carbon future," Ms Greening said.</p>},
      %Q{<p>There had been almost 55,000 responses to the consultation process on the project, which clearly "generates strong feelings, both in favour and against the scheme", the minister said:</p>},
      %Q{<p>She pledged a commitment to "developing a network with the lowest feasible impacts on local communities and the natural environment".</p>},
      %Q{<p>"I have been mindful that we must safeguard the natural environment as far as possible, both for the benefit of those enjoying our beautiful countryside today and for future generations."</p>},
      %Q{<p>Revisions to the route had halved the number of homes at risk, as well as reducing by a third the number due to experience increased noise, she said.</p>},
      %Q{<p>Changes to the plans, Ms Greening said, also meant that "more than half the route will now be mitigated by tunnel or cutting" and included new or extended tunnels at: Amersham in Buckinghamshire; Ruislip in north-west London; Greatworth in Northamptonshire; Turweston in Buckinghamshire; Chipping Warden and Aston le Walls in Northamptonshire; Wendover in Buckinghamshire; and Long Itchington Wood in Warwickshire.</p>},
      %Q{<p>Protest groups formed to oppose the scheme say the planned route crosses an area of outstanding natural beauty and it will damage the environment.</p>},
      %Q{<p>Opponents have also challenged the government's economic argument, suggesting the costs will be greater while the economic benefits will be lower than forecast, and that the business case for HS2 is based on an overly-optimistic prediction of growth in demand for long-distance train travel.</p>},
      %Q{<p>"There is no business case, no environmental case and there is no money to pay for it," said Stop HS2 campaign co-ordinator Joe Rukin.</p>},
      %Q{<p>"It's a white elephant of monumental proportions and you could deliver more benefits to more people more quickly for less money by investing in the current rail infrastructure."</p>},
      %Q{<p>Craig Bennett, director of policy and campaigns at Friends of the Earth, said: "We need to revolutionise travel away from roads and planes, but pumping £32bn into high-speed travel for the wealthy few while ordinary commuters suffer is not the answer.</p>},
      %Q{<p>"High-speed rail has a role to play in developing a greener, faster transport system, but current plans won't do enough to cut emissions overall - ministers should prioritise spending on improving local train and bus services instead."</p>},
      %Q{<p>However, the plan would be welcomed by "businesses up and down the country", said John Longworth, director general of the British Chambers of Commerce.</p>},
      %Q{<p>"Britain cannot continue to 'make do and mend' when it comes to its substandard infrastructure. Fundamentally, our global competitiveness is at stake," he said.</p>},
      %Q{<p>Stephen Joseph, chief executive of Campaign for Better Transport, said: "We're pleased to see the government investing in rail, rather than roads and aviation, and acting on some of the local environmental concerns surrounding HS2."</p>},
      %Q{<p>But he went on: "The process for deciding on the London-Birmingham part of HS2 has been too narrow and people feel left out.</p>},
      %Q{<p>"In consulting on the lines north of Birmingham, the government needs to involve people earlier with greater discussion of alternative options, including ways rail investment can support low-carbon growth in the communities served, and also how any new lines will integrate with existing networks and improve local as well as long-distance transport."</p>}
   ].join("\n")
  end
end

describe DataExtractor::VideoDocument do
  it "should extract body text correctly" do
    DataExtractor::VideoDocument.new(html("video")).body.should == [
      %Q{<p>Cricket star Andrew (Freddie) Flintoff confronts former tabloid editor Piers Morgan about how the press treat the nation's sporting heroes.</p>},
      %Q{<p>In 2007 he lost the England vice-captaincy after a session of binge drinking because of depression. He never read the press coverage at the time but admits if he had it could have put him over the edge.</p>},
      %Q{<p>Veteran soccer hard man Vinnie Jones backs him up with a few choice words about the media.</p>},
      %Q{<p>In <a href="http://www.bbc.co.uk/programmes/b019gbpk">Freddie Flintoff: Hidden Side of Sport</a> the cricket star talks to sporting professionals about the serious effects of depression. It will be on BBC One at 22.45 GMT on Wednesday 11 January 2012 and after on <a href="http://www.bbc.co.uk/iplayer/">BBC iPlayer</a></p>}
   ].join("\n")
  end
end

describe DataExtractor::PictureGalleryDocument do
  it "should extract body text correctly" do
    DataExtractor::PictureGalleryDocument.new(html("picture_gallery")).body.should == [
      %Q{<p>Models present creations from the Acquastudio collection during Fashion Rio Winter 2012 in Rio de Janeiro, Brazil.</p>},
      %Q{<p>Religious tensions have been growing in Nigeria as a general strike over rising petrol prices continues to grip the country. Gunmen have opened fire in a bar in the north of the country, killing eight people including several police officers.</p>},
      %Q{<p>Mitt Romney has won the Republican primary in New Hampshire with about 40% of the vote - another big step towards winning the party's nomination to take on Barack Obama for the White House in November. Attention now turns to the next state contest in the Republican race - South Carolina on 21 January.</p>},
      %Q{<p>Robbie Gordon of the USA drives his Hummer on stage nine of the 2012 Dakar Rally from Antofagasta to Iquique, Chile.</p>},
      %Q{<p>Park rangers fold a flag during a memorial service for Mount Rainier National Park Ranger Margaret Anderson, who was shot and killed after setting up a roadblock to stop a vehicle that broke through a checkpoint on the road to the park's visitor centre.</p>},
      %Q{<p>Great Britain's men won the Olympic test event in style to qualify a full team for the Games for the first time since Barcelona 1992.</p>},
      %Q{<p>Nicaragua's Daniel Ortega is inaugurated for a controversial third term as president after his landslide poll victory in November. Venezuela's Hugo Chavez and Iranian President Mahmoud Ahmadinejad were among the leaders attending the inauguration in the capital.</p>},
      %Q{<p>Members of a military band perform at the opening plenary session of the Shanghai Municipal People's Congress, China.</p>},
      %Q{<p>Riot police shield themselves from a Molotov cocktail thrown by residents during a violent demolition in San Juan, east of Manila, Philippines.</p>},
      %Q{<p>Heavy snow blocked roads and rail services in Austria. Several ski resorts including Lech and Zuers have been cut off.</p>}
   ].join("\n")
  end
  it "should extract images correctly" do
    images = DataExtractor::PictureGalleryDocument.new(html("picture_gallery")).images
    images.size.should == 10
    images.first.url.should == "http://news.bbcimg.co.uk/media/images/57817000/jpg/_57817107_013675006-1.jpg"
    images.first.description.should ==  "Models on a catwalk "
  end
end
