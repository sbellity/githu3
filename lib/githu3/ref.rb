module Githu3
  class Ref < Githu3::Resource
    
    def to_s
      url || html_url
    end
    
  end
end