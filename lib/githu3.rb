require 'ostruct'
require "uri"
require 'active_support'
require 'githu3/version'

require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/string/inflections'
require 'active_support/inflections'

require 'githu3/core_ext/hash'

module Githu3

  require 'githu3/error'
  require 'githu3/store'
  require 'githu3/relations'
  require 'githu3/resource'
  require 'githu3/resource_collection'
  require 'githu3/connection'
  require 'githu3/cache'
  require 'githu3/client'
  
  Resources = %w{
    branch
    comment 
    commit
    download
    event 
    git_commit
    issue 
    key 
    label 
    milestone 
    org 
    pull
    repo 
    tag 
    team 
    tree
    user 
  }

  Resources.each do |r|
    autoload r.camelize.to_sym, "githu3/#{r}"
  end
  
end







