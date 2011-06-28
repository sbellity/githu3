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
    
    def _path
      return if url.nil?
      URI.parse(url).path
    end
    
    def method_missing m, *args
      val = @attributes.send(m, *args)
      time_val = Time.parse(val) if m =~ /_at$/ rescue nil
      time_val || val
    end
    
    def _attributes
      @attributes
    end
    
    protected
    
    def _client
      @client
    end
  
  end
end