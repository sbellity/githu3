module Githu3
  
  class Resource
      
    extend Githu3::Relations
    
    def initialize(d, client)
      @client = client
      
      if d.is_a?(String)
        @attributes = Githu3::Store.new(client.get(d).body)
      else
        @attributes = Githu3::Store.new(d)
      end
    end
    
    def id
      @attributes.id
    end
    
    def get *args
      @client.get(*args)
    end
    
    def path
      return if url.nil?
      URI.parse(url).path
    end
    
    def method_missing m, *args
      @attributes.send(m, *args)
    end
    
    def _attributes
      @attributes
    end
    
    def date
      Time.parse(created_at) unless created_at.nil?
    end
    
    protected
    
    def _client
      @client
    end
  
  end
end