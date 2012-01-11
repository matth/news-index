require "spec_helper"

describe Image do

  it "should belong to article" do
    Image.new.respond_to?(:article).should == true
  end

  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:width) }
  it { should validate_presence_of(:height) }

  it 'should have a description' do
    Image.new.respond_to?(:description).should == true
  end

end