require 'forwardable'
require 'digest/sha1'

module Githu3
  class ResourceCollection
    
    include Enumerable
    extend Forwardable
    
    def_delegators :@resources, :each, :map, :<<, :length, :sort_by, :select, :detect, :find, :collect
    
    attr_reader :url, :fetch_error, :pagination, :current_page
    
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
      page = page || @current_page unless @current_page == 1
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
      @current_page = [1, params["page"].to_i].max
      @last_page = @pagination['last'] unless @pagination['last'].nil?
    end
    
    def fetch_next
      return [] if (@current_page + 1) > @last_page
      fetch(@current_page + 1)
    end

    def fetch_prev
      return [] if @current_page == 1
      fetch(@current_page - 1)
    end
    
    def fetch_last
      return [] unless @pagination["last"]
      fetch(@last_page)
    end
    
    def fetch_first
      fetch(1)
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