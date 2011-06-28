module Githu3

  module Relations
    
    def embeds_one m, opts={}
      opts[:class_name] ||= m.to_s
      define_method(m) do
        klass = Githu3.const_get(opts[:class_name].to_s.camelize)
        data = self._attributes.send(m)
        klass.new(data, @client) unless data.nil?
      end
    end
    
    def embeds_many m, opts={}
      opts[:class_name] ||= m.to_s.singularize
      define_method(m) do 
        klass = Githu3.const_get(opts[:class_name].to_s.camelize)
        data = self._attributes.send(m)
        data.map { |o| klass.new(o, @client) } unless data.nil?
      end
    end
    
    
    def has_many m, opts={}
      opts[:class_name] ||= m.to_s.singularize
      define_method(m) do |*args|
        params = args.extract_options!
        klass = Githu3.const_get(opts[:class_name].to_s.camelize)
        _resource_path = [opts[:nested_in], m].compact.join("/")
        if args.length == 1
          klass.new([_path, _resource_path, args.first].join("/"), @client)
        else
          Githu3::ResourceCollection.new(@client, klass, [_path, _resource_path].join("/"), params)
        end
      end
    end
  end
end