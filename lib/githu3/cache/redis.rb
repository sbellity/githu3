require 'redis'
require 'redis/namespace'

module Githu3
  module Cache
    class Redis
      attr_reader :config, :store
      
      DEFAULTS = { 
        :host       => 'localhost', 
        :port       => 6379, 
        :namespace  => :githu3,
        :expire     => 120
      } unless defined?(DEFAULTS)
      
      def initialize opts={}
        @config = DEFAULTS.merge(opts || {})
        redis = ::Redis.new :host => @config[:host], :port => @config[:port]
        @store = ::Redis::Namespace.new(@config[:namespace].to_sym, :redis => redis)
      end
      
      def get k
        val = @store[k.to_s]
        val = Marshal.load val unless val.nil?
        val
      end
      
      def set k, val, opts={}
        @store[k.to_s] = Marshal.dump(val)
        @store.expire k.to_s, (opts[:expire] || @config[:expire]).to_i
      end
      
    end
  end
end