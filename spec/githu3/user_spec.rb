require 'helper'

describe Githu3::User do

  def sbellity
    stub_get "/users/sbellity", "users/sbellity"
    @client.user("sbellity")
  end

  before do
    @client = Githu3::Client.new("myvalidtoken")
  end
  
  describe "Getting a users's stuff..." do
    
    it "should get a user's infos" do
      sbellity.login.should == "sbellity"
    end
    
    it "should get the user's public repos" do
      stub_get "/users/sbellity/repos", "users/repos"
      sbellity.repos.length.should == 5
    end
    
    it "should get the user's member repos" do
      stub_get "/users/sbellity/repos?type=member", "users/repos"
      sbellity.repos(:type => 'member').length.should == 5
    end
    
    it "should get the user's public orgs" do
      stub_get "/users/sbellity/orgs", "users/orgs"
      sbellity.orgs.length.should == 1
      sbellity.orgs.first.login.should == "sixdegrees"
    end
    
    it "should get the user's followers" do
      stub_get "/users/sbellity/followers", "users/followers"
      sbellity.followers.length.should == 13
    end
    
    it "should get the user's following" do
      stub_get "/users/sbellity/following", "users/following"
      sbellity.following.length.should == 30
    end
    
  end
end