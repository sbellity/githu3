require 'helper'

describe Githu3::Team do

  def team
    stub_get "/teams/1", "teams/1"
    @client.team "1"
  end
  

  before do
    @client = Githu3::Client.new("myvalidtoken")
  end
  
  describe "Getting the team's stuff..." do
    it "should get its name right" do
      team.name.should == "Owners"
    end
    
    it "should get its members" do
      
    end
  end
  
end