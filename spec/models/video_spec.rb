require "spec_helper"

describe Video do

  it "should belong to article" do
    Video.new.respond_to?(:article_id).should == true
  end

  it { should validate_presence_of(:playlist) }
  it { should validate_presence_of(:width) }
  it { should validate_presence_of(:height) }
  it { should validate_presence_of(:external_id) }

  it 'should have a holding image' do
    Video.new.respond_to?(:holding_image).should == true
  end

end