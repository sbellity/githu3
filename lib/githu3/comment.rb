module Githu3
  class Comment < Githu3::Resource
    
    embeds_one :user
    
    def _type
      m = url.match(/(issues|gists|pulls)\/comments\/[0-9]+$/)
      if m.nil? || m[1].nil?
        "commitcomment"
      else
        "#{m[1].singularize}comment"
      end
    end
    
    def _mime_type mt
      "application/vnd.github-#{_type}.#{mt}+json"
    end
    
  end
end