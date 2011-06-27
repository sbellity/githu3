require 'forwardable'

module Githu3
  class ResourceCollection
    
    include Enumerable
    extend Forwardable
    
    def_delegators :@resources, :each, :map, :<<, :length, :sort_by, :select, :detect, :find, :collect
    
    attr_reader :url, :fetch_error, :pagination
    
    def initialize client, resource_klass, url, params={}, opts={}
      @resource_klass = resource_klass
      @url = url
      @params = params
      @client = client
      @params = params.stringify_keys
      @pagination = {}
      @current_page = (@params["page"] || 1).to_i
      @resources = []
      @fetch_error = false
      fetch
      self
    end
    
    def fetch(page=nil)
      begin
        params = @params.dup.stringify_keys
        params["page"] = page unless page.nil?
        res = @client.get(@url, :params => params)
        update_pagination(res, params)
        fetched_resources = []
        res.body.map do |r| 
          resource = @resource_klass.new(r, @client)
          fetched_resources << resource
          @resources << resource unless @resources.include?(resource)
        end if res.body.is_a?(Array)
        fetched_resources
      rescue => err
        @fetch_error = err
        raise err
      end
    end
    
    def update_pagination(res, params)
      @pagination = parse_link_header(res.headers['link'])
      @current_page = params["page"].to_i
    end
    
    def fetch_next
      return [] unless @pagination["next"]
      fetch(@pagination["next"])
    end

    def fetch_prev
      return [] unless @pagination["prev"]
      fetch(@pagination["prev"])
    end
    
    def fetch_last
      return false unless @pagination["last"]
      fetch(@pagination["last"])
    end

    
    def parse_link_header src
      return {} if src.nil?
      links = src.scan(/<http[^<]+/i)
      return [] if links.nil?      
      links.inject({}) do |ll,l|
        m = /<(.*)>;(.*)rel=["|']([^"']*)["|'](.*)/i.match(l)
        uri = URI.parse(m[1])
        query = uri.query.split("&").inject({}) { |q,a| k,v=a.split("="); q.merge(k => v.to_i) }
        ll.merge(m[3] => query["page"])
      end
    end
            
  end
end