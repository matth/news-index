require "spec_helper"

describe Article do

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:publication_date) }
  it { should validate_presence_of(:site_name) }
  it { should validate_presence_of(:site_section) }
  it { should validate_presence_of(:cps_id) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:thumbnail) }
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

end