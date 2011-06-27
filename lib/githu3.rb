require 'ostruct'
require "uri"
require 'active_support'
require 'githu3/version'

require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/string/inflections'
require 'active_support/inflections'

module Githu3

  require 'githu3/error'
  require 'githu3/store'
  require 'githu3/relations'
  require 'githu3/resource'
  require 'githu3/resource_collection'
  require 'githu3/client'
  
  Resources = %w{ issue org team user tag branch repo key event comment label milestone }

  Resources.each do |r|
    autoload r.camelize.to_sym, "githu3/#{r}"
  end
  
end







