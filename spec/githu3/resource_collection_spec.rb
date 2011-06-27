require 'helper'

describe Githu3::ResourceCollection do

  def collection
    stub_get "/user/orgs", "orgs"
    Githu3::ResourceCollection.new(@client, Githu3::Org, "/user/orgs")
  end

  before do
    @client = Githu3::Client.new("myvalidtoken")
  end
  
  describe "Enumerable behaviour" do
  
    it "sould forward enumerable methods to @resource" do
      collection.length.should == 2
      collection.map { |o| o.login  }.sort.should == ['nuvoli', 'sixdegrees']
    end
    
  end
  
  describe "Pagination" do
    
    it "should paginate correctly" do
      stub_get "/user/repos?type=public", "public_repos"
      public_repos = Githu3::ResourceCollection.new(@client, Githu3::Org, "/user/repos", :type => "public")
      public_repos.length.should == 5
    end
    
    it "should set pagination options correctly" do
      stub_get "/user/repos?per_page=5&type=public", "public_repos"
      paginated = Githu3::ResourceCollection.new(@client, Githu3::Org, "/user/repos", :type => "public", :per_page => 5)
      paginated.length.should == 5
    end
    
    it "should correctly set pagination info" do
      link_header = <<-EOL
      <https://api.github.com/resource?page=2>; rel="next",
      <https://api.github.com/resource?page=5>; rel="last"
      EOL
                
      stub_request(:get, "https://api.github.com/user/repos?page=1&per_page=5&type=public").
        to_return(:headers => { "Link" => link_header })
      
      paginated = Githu3::ResourceCollection.new(@client, Githu3::Org, "/user/repos", :type => "public", :per_page => 5, :page => 1)
      paginated.pagination["next"].should == 2
      paginated.pagination["last"].should == 5
    end
    
  end
  
  describe "Error Handling" do
    
    it "should record an error... it one occurs" do
      stub_request(:get, "#{Githu3::Client::BaseUrl}/user/repos").to_return(:status => 401, :body => fixture('error.json'))
      lambda {
        Githu3::ResourceCollection.new(@client, Githu3::Org, "/user/repos")
      }.should raise_error(Githu3::Unauthorized)
    end
    
  end
  
end