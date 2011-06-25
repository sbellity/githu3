require 'helper'

describe Githu3::Repo do

  def faraday
    stub_get "/repos/technoweenie/faraday", "repos/faraday"
    @client.repo("technoweenie/faraday")
  end

  before do
    @client = Githu3::Client.new("myvalidtoken")
  end
  
  describe "Getting a repo's stuff..." do
    
    it "should get the repo infos" do
      faraday.name.should == "faraday"
      faraday.owner['login'].should == "technoweenie"
    end
    
    it "should fetch its contributors" do
      stub_get "/repos/technoweenie/faraday/contributors", "repos/faraday-contributors"
      faraday.contributors.length.should == 8
      faraday.contributors.first.login.should == "technoweenie"
    end

    it "should fetch its teams" do
      stub_get "/repos/technoweenie/faraday/teams", "repos/fake-team"
      teams = faraday.teams
      teams.length.should == 3
      teams.first.name.should == "Developers"
    end
    
    it "should fetch its tags" do
      stub_get "/repos/technoweenie/faraday/tags", "repos/faraday-tags"
      tags = faraday.tags
      tags.length.should == 18
      tags.first.name.should == "v0.5.6"
    end
    
    it "should fetch its branches" do
      stub_get "/repos/technoweenie/faraday/branches", "repos/faraday-branches"
      branches = faraday.branches
      branches.length.should == 3
      branches.first.name.should == "master"
    end
    
    
  end
end