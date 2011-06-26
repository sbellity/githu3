require 'helper'

describe Githu3::Repo do

  def repo
    stub_get "/repos/technoweenie/faraday", "repos/faraday"
    @client.repo("technoweenie/faraday")
  end

  def issue
    stub_get "/repos/technoweenie/faraday/issues/1", "repos/issue"
    repo.issues("1")
  end

  before do
    @client = Githu3::Client.new("myvalidtoken")
  end
  
  
  describe "Issue Events" do
    it "should fetch an issue's events" do
      stub_get "/repos/technoweenie/faraday/issues/1/events", "issues/events"
      issue.events.length.should == 1
    end
    
    it 'should Get a single event' do
      stub_get "/repos/technoweenie/faraday/issues/1/events/1", "issues/event"
      issue.events('1').event.should == "closed"
    end
  end
  
  describe "Issue Comments" do
    it "should get a comments list for the issue" do
      stub_get "/repos/technoweenie/faraday/issues/1/comments", "issues/comments"
      issue.comments.length.should == 3
    end
    
    it "should get a single comment" do
      # TODO... check if github updates the route...
      pending
    end
  end
  
  describe "Issue labels" do
    it "should list its labels" do
      stub_get "/repos/technoweenie/faraday/issues/1/labels", "repos/labels"
      issue.labels.length.should == 1
    end
    
    
  end
  
  
end