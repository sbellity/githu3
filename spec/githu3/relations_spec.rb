require 'helper'

describe Githu3::Relations do

  before do
    @client = Githu3::Client.new("myvalidtoken")

    class Githu3::Dummy < Githu3::Resource
    end

    class Githu3::DummyRelated < Githu3::Resource
    end
    
    class Githu3::DummyRelating < Githu3::Resource
      has_many :dummy_relateds
      has_many :dummies
      has_many :foos, :class_name => :dummy
    end
    
    class Githu3::DummyEmbedded
      extend Githu3::Relations
    end
    
    class Githu3::DummyMultiEmbedded
      extend Githu3::Relations
    end
    
    class Githu3::DummyEmbedding < Githu3::Resource
      embeds_one  :dummy_embedded
      embeds_one  :dummy, :class_name => :dummy_embedded
      embeds_many :dummy_multi_embeddeds
      embeds_many :dummies, :class_name => :dummy_multi_embedded
    end
    
  end
  
  describe "has_many" do
    
    it "should respond_to related" do
      
      rel = Githu3::DummyRelating.new({ :url => "https://api.github.com/dummy_relatings/123" }, @client)
      rel.should respond_to(:dummy_relateds)
      rel.should respond_to(:dummies)
      rel.should respond_to(:foos)
      
      dummy_response = ::MultiJson.encode([{ 
        :url => "https://api.github.com/dummy_relatings/123/dummy_relateds/1"
      }])
      
      stub_request(:get, "#{Githu3::Client::BaseUrl}/dummy_relatings/123/dummy_relateds")
          .to_return(:status => 200, :body => dummy_response)
      rel.dummy_relateds.first.url.should == "https://api.github.com/dummy_relatings/123/dummy_relateds/1"
      rel.dummy_relateds.first.should be_an_instance_of Githu3::DummyRelated


      stub_request(:get, "#{Githu3::Client::BaseUrl}/dummy_relatings/123/dummies")
          .to_return(:status => 200, :body => dummy_response)
      rel.dummies.first.should be_an_instance_of Githu3::Dummy
    end

  end
  
  describe "embeds" do
    
    it "should instanciate embedded resources" do
      emb = Githu3::DummyEmbedding.new({ 
        :url => "https://api.github.com/dummy_embeddings/123",
        :dummy_embedded => { :url => "https://api.github.com/dummy_embeddings/123/dummy_embedded/1" },
        :dummy => { :url => "https://api.github.com/dummy_embeddings/123/dummy_embedded/1312" },
        :dummy_multi_embeddeds => [{ :url => "https://api.github.com/dummy_embeddings/123/dummy_embedded/32" }],
        :dummies => [{ :url => "https://api.github.com/dummy_embeddings/123/dummy_embedded/132" }]
      }, @client)
      
      
      [:dummy_embedded, :dummy].each do |a|
        emb.should respond_to(a)
        emb.send(a).should be_an_instance_of Githu3::DummyEmbedded
      end
      
      [:dummy_multi_embeddeds, :dummies].each do |a|
        emb.should respond_to(a)
        emb.send(a).first.should be_an_instance_of Githu3::DummyMultiEmbedded
      end      
    end
  end

end