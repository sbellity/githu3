require 'rubygems'
require 'githu3'
require 'thor'
require 'yaml'

module Githu3
  
  class CLI < Thor
    
    desc "issues", "get the latest issues from a repo"
    def issues repo_name
      client = Githu3::Client.new
      begin
        repo = client.repo(repo_name)
        repo.issues.map do |issue|
          puts [issue.number.to_s.ljust(5), issue.assignee.to_s.ljust(25), issue.title.to_s].join("\t|\t")
        end
      rescue => err
        puts "Error: #{err.class.name}"
      end
    end
    
  end
  
end