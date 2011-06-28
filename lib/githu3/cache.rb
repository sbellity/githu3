module Githu3
  
  module Cache
    autoload :Redis,  "githu3/cache/redis"
    autoload :Disk,   "githu3/cache/disk"
  end
  
end