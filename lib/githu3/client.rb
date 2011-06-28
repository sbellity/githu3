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
    
    attr_reader :conn, :token
  
    def initialize(*args)
      opts = args.extract_options!
      @token = args.first
      headers = {}
      headers["Authorization"] = "token #{@token}" if @token
      @conn = Githu3::Connection.new headers, opts
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
      Githu3::User.new "/user", self
    end
    
    def orgs params={}
      Githu3::ResourceCollection.new(self, Githu3::Org, "/user/orgs", params)
    end
    
    def repos params={}
      Githu3::ResourceCollection.new(self, Githu3::Repo, "/user/repos", params)
    end
  
    def followers params={}
      Githu3::ResourceCollection.new(self, Githu3::User, "/user/followers", params)
    end
  
    def following params={}
      Githu3::ResourceCollection.new(self, Githu3::User, "/user/following", params)
    end
    
    def following?(other_user)
      begin
        get("/user/following/#{other_user}").status == 204
      rescue Githu3::NotFound
        false
      end
    end
  
  end

end