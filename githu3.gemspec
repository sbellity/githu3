# -*- encoding: utf-8 -*-
require File.expand_path('../lib/githu3/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = 'githu3'
  gem.summary = %q{Ruby wrapper for the GitHub's v3' API}
  gem.description = %q{Ruby wrapper for the GitHub's v3' API}
  gem.homepage = 'https://github.com/sbellity/githu3'
  gem.authors = ["Stephane Bellity"]
  gem.email = ['sbellity@gmail.com']

  gem.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  gem.files = `git ls-files`.split("\n")

  gem.platform = Gem::Platform::RUBY
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')

  gem.test_files = `git ls-files -- spec/*`.split("\n")

  gem.version = Githu3::VERSION.dup

  gem.add_runtime_dependency 'activesupport', '~> 3.0.0'
  gem.add_runtime_dependency 'i18n', '~> 0.5.0'
  gem.add_runtime_dependency 'faraday', '~> 0.6.0'
  gem.add_runtime_dependency 'faraday_middleware', '~> 0.6.0'
  gem.add_runtime_dependency 'multi_json', '~> 1.0.2'

  gem.add_development_dependency 'ZenTest', '~> 4.5'
  gem.add_development_dependency 'rake', '~> 0.9'
  gem.add_development_dependency 'rspec', '~> 2.6'
  gem.add_development_dependency 'simplecov', '~> 0.4'
  gem.add_development_dependency 'webmock', '~> 1.6'
  gem.add_development_dependency 'yajl-ruby', '~> 0.8'
end
