# -*- encoding: utf-8 -*-
require File.expand_path('../lib/githu3/version', __FILE__)

Gem::Specification.new do |s|
  s.name            = 'githu3'
  s.version         = Githu3::VERSION.dup
  s.summary         = %q{Ruby wrapper for the GitHub's v3' API}
  s.description     = %q{Ruby wrapper for the GitHub's v3' API}
  s.homepage        = 'https://github.com/sbellity/githu3'
  s.authors         = ['Stephane Bellity']
  s.email           = ['sbellity@gmail.com']

  s.executables     = 'githu3'
  s.files           = Dir['**/*'].select { |d| d =~ %r{^(LICENSE|README|bin/|lib/)} }
  
  s.platform        = Gem::Platform::RUBY
  s.require_paths   = ['lib']

  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')

  s.add_runtime_dependency      'activesupport',  '~> 3.0.0'
  s.add_runtime_dependency      'i18n',           '~> 0.5.0'
  s.add_runtime_dependency      'faraday',        '~> 0.6.0'
  s.add_runtime_dependency      'multi_json',     '~> 1.0.2'
  
  s.add_development_dependency  'ZenTest',        '~> 4.5'
  s.add_development_dependency  'rake',           '~> 0.9'
  s.add_development_dependency  'rspec',          '~> 2.6'
  s.add_development_dependency  'simplecov',      '~> 0.4'
  s.add_development_dependency  'webmock',        '~> 1.6'
  s.add_development_dependency  'yajl-ruby',      '~> 0.8'
end
