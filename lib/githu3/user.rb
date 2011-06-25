module Githu3

  class User < Githu3::Resource
    
    has_many :repos
    has_many :orgs
    has_many :keys
    has_many :followers, Githu3::User
    has_many :following, Githu3::User
    
  end

end
