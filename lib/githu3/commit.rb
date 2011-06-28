module Githu3
  class Commit < Githu3::Resource
    
    embeds_one :committer,  :class_name => :user
    embeds_one :author,     :class_name => :user
    embeds_one :commit,     :class_name => :git_commit
    
    def message
      _attributes.message || commit.message rescue nil
    end

  end
end
