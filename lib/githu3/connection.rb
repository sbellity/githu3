require 'digest/sha1'

module Githu3
  
  class Connection
    
    attr_reader :rate_limit, :cache, :conn
    
    
    
    def initialize opts={}
      @conn = Faraday.new({ :url => Githu3::Client::BaseUrl })
      
      @conn.adapter opts[:adapter] if opts[:adapter]
      @conn.use FaradayMiddleware::ParseJson
      @conn.use Faraday::Response::RaiseGithu3Error
      
      if opts[:cache]
        cache_klass = Githu3::Cache.const_get(opts[:cache].to_s.camelize)
        @cache = cache_klass.new(opts[:cache_config])
      end
      
      yield @conn if block_given?
      
      @rate_limit = {}
    end
    
    def get url, headers={}, opts={}
      use_cache = !@cache.nil? && !opts[:bypass_cache]
      if use_cache
        ref = Digest::SHA1.hexdigest [url, headers.to_s].join("")
        res = @cache.get ref
        return res unless res.nil?
      end
      res = @conn.get(url, headers)
      if use_cache
        @cache.set(ref, res) if res.status < 400
      else
        @rate_limit[:limit] = res.headers["x-ratelimit-limit"]
        @rate_limit[:remaining] = res.headers["x-ratelimit-remaining"]
      end
      res
    end
    
  end
  
end