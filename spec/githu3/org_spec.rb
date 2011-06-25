require 'helper'

describe Githu3::Org do

  def github
    stub_get "/orgs/github", "/orgs/github"
    @client.org "github"
  end

  before do
    @client = Githu3::Client.new("myvalidtoken")
  end

  it "should get its name right" do
    github.name.should == "GitHub"
  end
  
  describe "Getting an org's stuff..." do
    
  end
end