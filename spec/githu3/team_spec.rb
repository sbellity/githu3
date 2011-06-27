require 'helper'

describe Githu3::Team do

  def team
    stub_get "/teams/1", "teams/1"
    @client.team "1"
  end
  

  before do
    @client = Githu3::Client.new("myvalidtoken")
  end

  it "should get its name right" do
    team.name.should == "Owners"
  end
  
  describe "Getting the team's members..." do
    
    it "should get its members" do
      stub_get "/teams/1/members", "teams/members"
      team.members.length.should == 1
      team.members.first.login.should == "octocat"
    end
    
    it 'should tell me if a user IS a member of the team' do
      stub_request(:get, "#{Githu3::Client::BaseUrl}/teams/1/members/octocat").to_return(:status => 204)
      team.member?('octocat').should be_true
    end    
    
    it 'should tell me if a user IS NOT a member of the team' do
      stub_request(:get, "#{Githu3::Client::BaseUrl}/teams/1/members/billevans").to_return(:status => 404)
      team.member?('billevans').should be_false
    end
  end

  describe "Getting the team's repos..." do

    it "should list the team's repos" do
      stub_get "/teams/1/repos", "teams/repos"
      team.repos.length.should == 1
    end
    
  end
  
end