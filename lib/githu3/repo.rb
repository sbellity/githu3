require 'githu3/user'
require 'githu3/team'
require 'githu3/tag'
require 'githu3/branch'

module Githu3
  class Repo < Githu3::Resource
    
    has_many :contributors, Githu3::User
    has_many :teams
    has_many :tags
    has_many :branches
    
  end
end