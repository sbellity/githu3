module Githu3
  class Issue < Githu3::Resource
    
    has_many :events
    has_many :comments
    has_many :labels
    
  end
end