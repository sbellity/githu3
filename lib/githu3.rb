require 'ostruct'
require 'faraday'
require 'faraday_middleware'
require "uri"
require 'active_support'
require 'githu3/version'

require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/string/inflections'
require 'active_support/inflections'

module Githu3
  
  Resources = %w{ issue org team user tag branch repo key }

  autoload :Resource, 'githu3/resource'
  autoload :Client,   'githu3/client'
  
  Resources.each do |r|
    autoload r.camelize.to_sym, "githu3/#{r}"
  end
  
end







