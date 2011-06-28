module Githu3
  
  module Cache
    autoload :Redis,  "githu3/cache/redis"
    autoload :File,   "githu3/cache/file"
  end
  
end