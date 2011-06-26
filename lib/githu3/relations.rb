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
end