module Githu3
  class Issue < Githu3::Resource
    
    has_many :events
    has_many :comments
    
    # members
    embeds_many :labels
    embeds_one  :user
    embeds_one  :milestone
    embeds_one  :assignee, :class_name => :user
    
    def _mime_type mt
      "application/vnd.github-issue.#{mt}+json"
    end
        
  end
end