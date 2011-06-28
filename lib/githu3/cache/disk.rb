require 'fileutils'

module Githu3
  module Cache
    class Disk
      attr_reader :config, :store
      
      DEFAULTS = { 
        :path       => '/tmp/githu3',
        :namespace  => 'cache',
        :expire     => 120
      } unless defined?(DEFAULTS)
      
      def initialize opts={}
        @config = DEFAULTS.merge(opts || {})
        @path = ::File.expand_path(::File.join(@config[:path], @config[:namespace]))
        FileUtils.mkdir_p @path
      end
      
      def get k
        val = nil
        file_path = ::File.join(@path, k)
        if ::File.exists?(file_path)
          if (Time.now - ::File.atime(file_path)) < @config[:expire]
            val = Marshal.load(::File.read(file_path))
          else
            FileUtils.rm(file_path)
          end
        else
        end
        val
      end
      
      def set k, val, opts={}
        file_path = ::File.join(@path, k)
        f = open(file_path, 'wb')
        f.write(Marshal.dump(val))
        f.close
      end
      
    end
  end
end