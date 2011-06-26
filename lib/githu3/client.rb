
module Githu3

  class Client
  
    attr_reader :conn, :rate_limit
  
    def initialize(oauth_token=nil)
      headers = {}
      headers["Authorization"] = "token #{oauth_token}" if oauth_token
      @conn = Faraday.new({
        :url => "https://api.github.com/", 
        :headers => headers
      })
      @conn.use Faraday::Response::ParseJson
      @rate_limit = {}
      @conn
    end
  
    def get *args
      opts = args.extract_options!
      res = @conn.get(*args) do |req|
        if opts[:params].is_a?(Hash)
          req.params ||= {}
          opts[:params].each { |k,v| req.params[k.to_s] = v.to_s }
        end
      end
      @rate_limit[:limit] = res.headers["x-ratelimit-limit"]
      @rate_limit[:remaining] = res.headers["x-ratelimit-remaining"]
      res.body
    end
    
    # Top level resources...
    %w{ org repo team user }.each do |r|
      define_method r do |ident|
        Githu3.const_get(r.camelize).new(get("/#{r.pluralize}/#{ident}"), self)
      end
    end

    # My stuf...

    def me
      Githu3::User.new "/user", self
    end
    
    def orgs
      get("/user/orgs").map { |o| Githu3::Org.new(o, self) }
    end
    
    def repos(params={})
      get("/user/repos", :params => params).map { |r| Githu3::Repo.new(r,self) }
    end
  
    def followers
      get("/user/followers").map { |u| Githu3::User.new(u, self) }
    end
  
    def following
      get("/user/following").map { |u| Githu3::User.new(u, self) }
    end
    
    def following?(other_user)
      @conn.get("/user/following/#{other_user}").status == 204
    end
  
  end

end