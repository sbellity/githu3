module Githu3

  module Relations

    def has_many m, opts={}
      opts[:class_name] ||= m.to_s.singularize
      define_method(m) do |*args|
        params = args.extract_options!
        klass = Githu3.const_get(opts[:class_name].to_s.camelize)
        _resource_path = [opts[:nested_in], m].compact.join("/")
        if args.length == 1
          klass.new([path, _resource_path, args.first].join("/"), @client)
        else
          get([path, _resource_path].join("/"), :params => params).map { |o| klass.new(o, @client) }
        end
      end
    end
  end
  
  class Store
    
    attr_reader :id
    
    def initialize data
      @id = data[:id] || data["id"]
      @attributes = OpenStruct.new(data)
    end
    
    def method_missing m, *args
      @attributes.send m, *args
    end
    
  end
  
  class Resource < Store
      
    extend Githu3::Relations
  
    def initialize(d, client)
      @client = client
      if d.is_a?(String)
        super(client.get(d))
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