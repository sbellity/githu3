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
      faraday.owner.login.should == "technoweenie"
    end
    
    it "should fetch its contributors" do
      stub_get "/repos/technoweenie/faraday/contributors", "repos/contributors"
      faraday.contributors.length.should == 8
      faraday.contributors.first.login.should == "technoweenie"
    end

    it "should fetch its teams" do
      stub_get "/repos/technoweenie/faraday/teams", "repos/teams"
      teams = faraday.teams
      teams.length.should == 3
      teams.first.name.should == "Developers"
    end
    
  end
  
  describe "Getting a repo's refs" do
    
    it "should fetch its tags" do
      stub_get "/repos/technoweenie/faraday/tags", "repos/tags"
      tags = faraday.tags
      tags.length.should == 18
      tags.first.name.should == "v0.5.6"
    end
    
    it "should fetch its branches" do
      stub_get "/repos/technoweenie/faraday/branches", "repos/branches"
      branches = faraday.branches
      branches.length.should == 3
      branches.first.name.should == "master"
    end

  end
  
  describe "Wokring with its issues..." do
    
    it "should list its issues" do
      stub_get "/repos/technoweenie/faraday/issues", "repos/issues"
      faraday.issues.length.should == 1
    end
    
    it "should filter its issues" do
      stub_get "/repos/technoweenie/faraday/issues?state=open&labels=bug,feature", "repos/issues"
      faraday.issues(:state => "open", :labels => "bug,feature").length.should == 1
    end
    
    it "should fetch a single issue" do
      stub_get "/repos/technoweenie/faraday/issues/1", "repos/issue"
      faraday.issues("1").state.should == "open"
    end

    it "should list its issues" do
      stub_get "/repos/technoweenie/faraday/issues/events", "issues/events"
      faraday.events.length.should == 1
    end

    it "should list its labels" do
      stub_get "/repos/technoweenie/faraday/labels", "repos/labels"
      faraday.labels.length.should == 1
      faraday.labels.first.name.should == "bug"
    end

    it "should get a single labels" do
      stub_get "/repos/technoweenie/faraday/labels/bug", "repos/label"
      faraday.labels("bug").name.should == "bug"
    end
    
    it "should list its milestones" do
      stub_get "/repos/technoweenie/faraday/milestones", "repos/milestones"
      faraday.milestones.length.should == 1
      faraday.milestones.first.title.should == "v1.0"
    end
    
    it "should get a single milestone" do
      stub_get "/repos/technoweenie/faraday/milestones/1", "repos/milestone"
      faraday.milestones("1").title.should == "v1.0"
    end
    
  end
  
end