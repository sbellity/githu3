require 'faraday'
require 'faraday_middleware'
require 'faraday/response/raise_githu3_error'
require 'uri'
require 'active_support/core_ext/hash'

module Githu3

  class Client
    
    BaseUrl = "https://api.github.com"
    
    attr_reader :conn, :rate_limit
  
    def initialize(oauth_token=nil)
      headers = {}
      headers["Authorization"] = "token #{oauth_token}" if oauth_token
      @conn = Faraday.new({
        :url => Githu3::Client::BaseUrl, 
        :headers => headers
      })
      
      @conn.use Faraday::Response::ParseJson
      @conn.use Faraday::Response::RaiseGithu3Error
      
      @rate_limit = {}
      @conn
    end
  
    def get *args
      opts = args.extract_options!
      uri = URI.parse(args.shift)
      uri_params = (opts[:params] || {}).stringify_keys
      unless uri.query.nil?
        uri_params.merge(uri.query.split("&").inject({}) { |m,p| k,v=p.split("=", 2); m.merge(k => v)  } )
      end
      args.unshift uri.path
      res = @conn.get(*args) do |req|
        req.params = uri_params
        if opts[:params].is_a?(Hash)
          opts[:params].each { |k,v| req.params[k.to_s] = v.to_s }
        end
      end
      @rate_limit[:limit] = res.headers["x-ratelimit-limit"]
      @rate_limit[:remaining] = res.headers["x-ratelimit-remaining"]
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