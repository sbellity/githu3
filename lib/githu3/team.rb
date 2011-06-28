module Githu3

  class Team < Githu3::Resource
    
    has_many :members, :class_name => :user
    has_many :repos
    
    def to_s
      name
    end
    
    def member?(user_login)
      begin
        _client.conn.get("/teams/#{id}/members/#{user_login}").status == 204
      rescue Githu3::NotFound
        false
      end
    end
        
  end

end
