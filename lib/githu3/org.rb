require 'githu3/repo'

module Githu3
  class Org < Githu3::Resource
    
    has_many :repos
    has_many :teams
    has_many :members, :class_name => :user
    has_many :public_members, :class_name => :user
    
    def member?(user_login)
      _client.conn.get("/orgs/#{login}/members/#{user_login}").status == 204
    end
    
    def public_member?(user_login)
      _client.conn.get("/orgs/#{login}/public_members/#{user_login}").status == 204
    end
    
  end
end