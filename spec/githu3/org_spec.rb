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
  
  describe "Getting an org's members..." do
    
    it "should get its members" do
      stub_get "/orgs/github/members", "teams/members"
      github.members.length.should == 1
      github.members.first.login.should == "octocat"
    end
    
    it 'should tell me if a user IS a member of the team' do
      stub_request(:get, "#{Githu3::Client::BaseUrl}/orgs/github/members/octocat").to_return(:status => 204)
      github.member?('octocat').should be_true
    end    
    
    it 'should tell me if a user IS NOT a member of the org' do
      stub_request(:get, "#{Githu3::Client::BaseUrl}/orgs/github/members/billevans").to_return(:status => 404)
      github.member?('billevans').should be_false
    end    
    
    it "should get its teams" do
      stub_get "/orgs/github/teams", "repos/teams"
      github.teams.length.should == 3
      github.teams.first.name.should == "Developers"
    end
    
  end
  
  describe "Getting an org's public_members..." do
    
    it "should get its public_members" do
      stub_get "/orgs/github/public_members", "teams/members"
      github.public_members.length.should == 1
      github.public_members.first.login.should == "octocat"
    end
    
    it 'should tell me if a user IS a public_member of the team' do
      stub_request(:get, "#{Githu3::Client::BaseUrl}/orgs/github/public_members/octocat").to_return(:status => 204)
      github.public_member?('octocat').should be_true
    end    
    
    it 'should tell me if a user IS NOT a public_member of the team' do
      stub_request(:get, "#{Githu3::Client::BaseUrl}/orgs/github/public_members/billevans").to_return(:status => 404)
      github.public_member?('billevans').should be_false
    end    
  end
  
  describe "Getting the org's repos" do
    
    it "should get its repos" do
      stub_get "/orgs/github/repos", "all_repos"
      github.repos.length.should == 2
    end
    
    it "should get its public repos" do
      stub_get "/orgs/github/repos?type=public", "public_repos"
      github.repos(:type => "public").length.should == 5
    end
    
    
  end
  
  
end