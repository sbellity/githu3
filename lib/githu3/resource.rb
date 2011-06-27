module Githu3
  
  class Resource < Githu3::Store
      
    extend Githu3::Relations
    
    def initialize(d, client)
      @client = client
      if d.is_a?(String)
        super(client.get(d).body)
      else
        super(d)
      end
    end
    
    def get *args
      @client.get(*args)
    end
    
    def path
      return if url.nil?
      URI.parse(url).path
    end
    
    protected
    
    def _client
      @client
    end
  
  end
end