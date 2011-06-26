module Githu3

  class User < Githu3::Resource
    
    has_many :repos
    has_many :orgs
    has_many :keys
    has_many :followers, :class_name => :user
    has_many :following, :class_name => :user
    
  end

end
