$:.unshift File.expand_path('../../lib', __FILE__)
require 'githu3'

# To run this test:
# > bundle exec ruby examples/public_stuff.rb

c = Githu3::Client.new

rails = c.repo "rails/rails"

puts "Rails has #{rails.open_issues} open issues... last push occured @ #{rails.pushed_at}"
puts "===================================================================================="
rails.issues(:state => "open").each do |issue|
  puts " > #{issue.number.to_s.rjust(6)} | #{issue.created_at} | #{issue.assignee.to_s.ljust(24)} | #{issue.title.to_s}"
end