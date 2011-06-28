module Githu3
  class Event < Githu3::Resource
    
    embeds_one :issue
    
    def to_s
      "#{date}: #{actor['login']} #{event} #{issue.title}"
    end
   
  end
end