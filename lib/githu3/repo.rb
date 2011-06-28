module Githu3
  class Repo < Githu3::Resource
    has_many :contributors, :class_name => :user
    has_many :watchers,     :class_name => :user
    has_many :forks,        :class_name => :repo
    has_many :teams
    has_many :tags
    has_many :commits
    has_many :refs,         :nested_in => :git
    has_many :trees,        :nested_in => :git
    has_many :branches
    has_many :issues
    has_many :events,       :nested_in => :issues
    has_many :labels
    has_many :milestones
    has_many :keys
    has_many :comments
    # has_many :downloads # not working... always returns an empty body
    
    embeds_one :owner,      :class_name => :user
    
    def to_s
      [owner, name].join("/")
    end
  end
end