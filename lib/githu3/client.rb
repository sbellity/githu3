require 'faraday'
require 'faraday/response/raise_githu3_error'
require 'faraday/response/parse_json'
require 'uri'
require 'forwardable'
require 'active_support/core_ext/hash'

module Githu3

  class Client
    
    extend Forwardable
    
    BaseUrl = "https://api.github.com"
    
    def_delegator :conn, :rate_limit
    
    attr_reader :conn, :auth
  
    def initialize(*args)
      opts = args.extract_options!
      @conn = Githu3::Connection.new opts do |c|
        case args.length
        when 1
          @auth = :token
          c.headers["Authorization"] = "token #{args.first}"
        when 2
          @auth = :basic
          c.basic_auth(*args)
        end
      end
    end
    
    def authenticated?
      !!@auth
    end
    
    def get *args
      opts = args.extract_options!
      uri = URI.parse(args.shift)
      uri.query = (opts[:params] || {}).stringify_keys.merge(Hash.from_url_params(uri.query || "")).to_url_params
      
      res = @conn.get(uri, opts[:headers])
      res
    end
    
    # Top level resources...
    %w{ org repo team user }.each do |r|
      define_method r do |ident|
        Githu3.const_get(r.camelize).new(get("/#{r.pluralize}/#{ident}").body, self)
      end
    end

    # My stuf...

    def me
      require_auth
      Githu3::User.new "/user", self
    end
    
    def orgs params={}
      require_auth
      Githu3::ResourceCollection.new(self, Githu3::Org, "/user/orgs", params)
    end
    
    def repos params={}
      require_auth
      Githu3::ResourceCollection.new(self, Githu3::Repo, "/user/repos", params)
    end
  
    def teams
      require_auth
      Githu3::ResourceCollection.new(self, Githu3::Team, "/user/teams")
    end
  
    def followers params={}
      require_auth
      Githu3::ResourceCollection.new(self, Githu3::User, "/user/followers", params)
    end
  
    def following params={}
      require_auth
      Githu3::ResourceCollection.new(self, Githu3::User, "/user/following", params)
    end
    
    def following?(other_user)
      require_auth
      begin
        get("/user/following/#{other_user}").status == 204
      rescue Githu3::NotFound
        false
      end
    end
    
    protected
    
    def require_auth
      raise Githu3::Unauthorized, "You must me logged in to use this method" unless authenticated?
      yield if block_given?
    end
    
  end

end