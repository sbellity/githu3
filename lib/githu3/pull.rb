module Githu3
  class Pull < Githu3::Resource
    
    def to_s
      url || html_url
    end
    
  end
end