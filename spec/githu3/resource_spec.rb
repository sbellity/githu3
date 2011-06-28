require 'helper'

describe Githu3::Resource do

  class Githu3::MyFabulousResource < Githu3::Resource
  end

  before do
    @client = Githu3::Client.new("myvalidtoken")
  end
  
  describe "Data Store" do
    
    it "must store whatever hash you give it..." do
      r = Githu3::MyFabulousResource.new({ "a" => "A", :b => "B"}, @client)
      r.a.should == "A"
      r.b.should == "B"
      r.c.should == nil
    end
    
    it "must fetch data if you pass a string as first argument to the constructor" do
      stub_request(:get, "https://api.github.com/my_fabulous_resources/yo").
               to_return(:status => 200, :body => '{"name" : "toto"}', :headers => {})
      r = Githu3::MyFabulousResource.new('/my_fabulous_resources/yo', @client)
      r.name.should == 'toto'
    end

    it "must keep the id given (1.8.7 bug...)" do
      stub_request(:get, "https://api.github.com/my_fabulous_resources/yo").
               to_return(:status => 200, :body => '{"id" : "toto"}', :headers => {})
      r = Githu3::MyFabulousResource.new('/my_fabulous_resources/yo', @client)
      r.id.should == 'toto'
    end
    
    it "id must be nil if not provided..." do
      stub_request(:get, "https://api.github.com/my_fabulous_resources/yo").
               to_return(:status => 200, :body => '{"name" : "toto"}', :headers => {})
      r = Githu3::MyFabulousResource.new('/my_fabulous_resources/yo', @client)
      r.id.should be_nil
    end
    
    it "must parse the path from its url attribute" do
      stub_request(:get, "https://api.github.com/my_fabulous_resources/yo").
               to_return(:status => 200, :body => '{"url" : "https://api.github.com/my_fabulous_resources/yo"}')
      r = Githu3::MyFabulousResource.new('/my_fabulous_resources/yo', @client)
      r._path.should == "/my_fabulous_resources/yo"
    end

    it "path should be nil if no url provided..." do
      stub_request(:get, "https://api.github.com/my_fabulous_resources/yo").
               to_return(:status => 200, :body => '{"name" : "yo"}')
      r = Githu3::MyFabulousResource.new('/my_fabulous_resources/yo', @client)
      r._path.should be_nil
    end
    
  end
  
end