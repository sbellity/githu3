# githu3

githu3 is a ruby wrapper for github's v3 api.


## Installation

    gem install githu3
    
## Usage
  
### Authentication

There are two ways to authenticate

Basic Authentication:

    client = Githu3::Client.new('username', 'password')

OAuth2 Token (send in a header): 

    client = Githu3::Client.new('myawesomelyverylongoauth2token')
    
Or you can use the lib as an un-authenticated client to access only public Github resources...
  
    client = Githu3::Client.new

### Getting the basics

The Githu3::Client instance can directly access github's top-level resources : orgs, repos, teams and users

to get them : 
    
    c = Githu3::Client.new

    # Org
    rails_org = c.org 'rails' # -> 'rails' organization wrapped in a Gihu3::Org object
    
    # Repo
    rails_repo = c.repo 'rails/rails' # -> That's Rails !
    
    # User
    sbellity = c.user 'sbellity' # -> That's me !

    # Team
    a_team = c.team 123 # -> well... team number '123' if you have access to it
    

### Getting your stuff

When authenticated, your Githu3::Client instance can give you direct access to your top-level stuff... 

    me = Githu3::Client.new 'myawesomelyverylongoauth2token'
    
    # Orgs
    # returns a paginable Githu3::ResourceCollection stuffed with YOUR organizations
    # more on this Githu3::ResourceCollection thing later...
    my_orgs = me.orgs
    
    # Repos
    my_repos = me.repos
    
    # Me
    me = me.me                # -> well, you get the point...

    # Followers
    me.following              # -> returns a list a the Githu3::User, that you follow
    me.followers              # -> returns a list a the Githu3::User, that follow you
    me.following?("rails")    # -> true if you follow 'rails', false otherwise
    

### Getting deeper inside the API with Githu3::Resource Objects

All the calls to the API either return Githu3::Resource objects (ex. Githu3::User, Githu3::Repo, Githu3::Org...) et Githu3::ResourceCollection objects that wrap... Githu3::Resource objects
    
#### Attributes

All the member attributes are accessible directly via their names. If you try to access an attribute that does not exist... you'll get `nil`

Examples: 

    c = Githu3::Client.new
    
    rails_org = c.org 'rails'
    rails_org.login           # -> 'rails'
    rails_org.html_url        # -> 'https://github.com/rails'
    rails_org.public_repos    # -> 44
    rails_org.foo             # -> nil


#### Relations

Relations between the Resources follow the nesting of the Github's REST Api. For example, you can get the list of an org's repos directly from the Githu3::Org object. 

    c = Githu3::Client.new
    rails_org = c.org "rails"
    rails_org.repos # -> the list of rails' repos

You can even do this !

    rails_org.repos.first.issues # -> latest issues from rails' first repo


#### Embedding

Github often embeds objects inside others. For example, rails Repo has an owner object, that is a Githu3::User object... which let you do this: 

    rails_repo = c.repo "rails/rails"
    rails_repo.owner  # -> rails org wrapped in a Githu3::User object
    


### Getting lots of stuff with Githu3::ResourceCollection Objects

#### Acts as Enumerable

Most results from the Api calls are collections of stuff. Those collections are wrapped in Githu3::ResourceCollection objects that primarily act as Arrays. Meaning that you can safely call the usual `length`, `first`, `last`, `each`, `map`, `select`... an so on... on them.

#### Pagination

_Warning !... this Pagination api is very alpha-ish... and very susceptible to change_

In fact, Github's api generally returns [paginated results](http://developer.github.com/v3/#pagination). Github::ResourceCollection have a pagination api built right in, that lets you do those kinds of stuff : 

    rails_repo = c.repo "rails/rails"
    rails_issues = rails_repo.issues(:per_page => 10, :page => 4) # -> :per_page defaults to 30, :page defaults to 1
    
    rails_issues.current_page               # -> 4
    rails_issues.length                     # -> 10
    
    next_issues = rails_issues.fetch_next   # -> next_issues is a plain Array here... 
                                            # new records are added to your original collection
    rails_issues.current_page               # -> 5
    rails_issues.length                     # -> 20


#### Filtering & Sorting

Github Api provides filter options for most collection calls. To use a filter on your Githu3::ResourceCollection object, you can do 

    repo  = c.repo "sbellity/githu3"
    open_issues = repo.issues :state => "open"
    bugs        = repo.issues :tag => "bug"
    my_issues   = repo.issues :assignee => "sbellity"
    
    # You can also combine and sort them
    my_open_bugs = repo.issues  :assignee => "sbellity", 
                                :tag => "bug", 
                                :state => "open", 
                                :sort => "updated", 
                                :direction => "desc"



### Rate limiting

Your app may generate a LOT of requests to Github's API... By default, you are rate-limitted to 5000 requests per day. You can check anytime the status of your allowance via the method "rate_limit" on your Githu3::Client instance.

    c = Githu3::Client.new
    ...
    c.rate_limit  # -> {:limit=>"5000", :remaining=>"4969"}


### Caching results

Githu3 provides a very basic cache mechanism to avoid making duplicate requests too often. Basically what it does is just record HTTP request results in a store with an expiration timeout and attempts to retrieve the results back from this store before hitting Github's servers. The different clients private data... should be safe, the request headers (that contain auth info) are used to generate the hash. 2 stores are provided by default : Redis and Disk.

To use them (these are the default options):

    disk_cached_client = Githu3::Client.new('myawesomelyverylongoauth2token', :cache => :disk, :cache_config => {
      :path       => "/tmp/githu3", 
      :namespace  => "cache",       # or "myawesomelyverylongoauth2token" if you are paranoid...
      :expire     => 120            # in seconds
    })

    require 'redis'
    require 'redis-namespace'
    redis_cached_client = Githu3::Client.new('myawesomelyverylongoauth2token', :cache => :redis, :cache_config => {
      :host       => "localhost",     # defaults to localhost
      :port       => 6379             # defaults to 6379
      :namespace  => "githu3",        # or "githu3:myawesomelyverylongoauth2token" if you are paranoid...
      :expire     => 120              # in seconds
    })


## Limitations / Known issues

* The current version (0.1.x branch) only supports read (GET) operations on Github... support for CREATE / UPDATE operations should show up in the the 0.2.x branch.
* Github's api is still in beta, so this lib could break anytime if they change something, stay tuned for new versions and please report any issue on the project issue tracker.
* Some calls (ex. `c.repo('rails/rails').issues` -> 2 HTTP GET) make unnecessary calls to github, we will try to find a way to avoid this overhead in a future version.
* This lib is VERY young, please be kind and help me improve it


## Contributing to githu3
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.


## Copyright

Copyright (c) 2011 Stephane Bellity. See LICENSE.txt for
further details.

