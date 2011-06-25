require 'githu3/repo'

module Githu3
  class Org < Githu3::Resource
    
    has_many :repos
    has_many :teams
    
  end
end