module Githu3
  class Comment < Githu3::Resource
    
    embeds_one :user
    
    
  end
end